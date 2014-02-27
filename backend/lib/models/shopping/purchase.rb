class Purchase < ActiveRecord::Base

  attr_accessible :user_id, :payment_method_id, :billing_address_id, :shipping_address_id

  has_many :orders

  belongs_to :payment_method
  belongs_to :billing_address,  class_name: "Address"
  belongs_to :shipping_address, class_name: "Address"
  belongs_to :payment
  belongs_to :user

  before_validation :set_values, on: :create

  validates :committed, uniqueness: { scope: :user_id }, unless: :committed?
  validates :committed_at, presence: true, if: :committed?

  validates :user_id,             presence: true 
  validates :payment_method_id,   presence: true, if: :committed?
  validates :billing_address_id,  presence: true, if: :committed?
  validates :shipping_address_id, presence: true, if: :committed?

  validates :user,             presence: true
  validates :payment_method,   presence: true, if: :committed?
  validates :billing_address,  presence: true, if: :committed?
  validates :shipping_address, presence: true, if: :committed?

  scope :committed, -> { where(committed: true) }
  scope :pending,   -> { where(committed: false) }

  delegate :currency, to: :payment_method, prefix: true

  def self.pending_purchase(user_id)
    where(user_id: user_id).pending.first_or_create
  end

  def self.add_order(user_id, item_type, item_id, currency_id, quantity)
    pending_purchase(user_id).add_order(item_type, item_id, currency_id, quantity)
  end

  def self.remove_order(user_id, order_id)
    pending_purchase(user_id).remove_order(order_id)
  end

  def add_order(item_type, item_id, currency_id, quantity)
    if persisted? && pending?
      order = orders.kept.where(item_type: item_type, item_id: item_id).first_or_initialize
      order.currency_id = currency_id
      order.quantity    = quantity
      order.save ? order : nil
    end
  end

  def remove_order(order_id)
    if persisted? && pending?
      order = orders.kept.find_by_id(order_id) || orders.kept.find_by_uuid(order_id)
      order.present? && order.delete! ? order : nil
    end
  end

  def pending?
    !committed?
  end

  [:amount, :tax].each do |method|
    define_method method do |currency=nil|
      currency   = Currency.find_by_code(currency) unless currency.instance_of?(Currency)
      currency ||= payment_method_currency
      orders.kept.reduce(BigDecimal("0.0")) { |s,o| s += Currency.exchange(o.send(method), o.currency.code, currency.code) } 
    end
  end

  def commit!
    if persisted? && pending?
      self.committed    = true
      self.committed_at = DateTime.now
      save
    end
  end

  def fulfill!
    if persisted? && committed?
      if payment_method.enough?(amount)
        begin
          ActiveRecord::Base.transaction do
            payment = create_payment(
              attributes.slice(
                :user_id, 
                :payment_method_id, 
                :billing_address_id
              ).merge(
                amount: amount, 
                currency_id: payment_method_currency.id
              )
            )

            payment.commit! if orders.kept.all?{ |order| order.fulfill! }
          end
          true
        rescue Fulfillment::FulfillmentFailure => ex
          false
        end
      end
    end
  end

  protected

  def set_values
    self.committed    = false
    self.committed_at = nil
    true
  end
end