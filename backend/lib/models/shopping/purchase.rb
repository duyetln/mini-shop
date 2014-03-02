class Purchase < ActiveRecord::Base

  attr_accessible :user_id, :payment_method_id, :billing_address_id, :shipping_address_id

  has_many :orders

  belongs_to :payment_method
  belongs_to :billing_address,  class_name: "Address"
  belongs_to :shipping_address, class_name: "Address"
  belongs_to :payment
  belongs_to :user

  before_validation :set_values, on: :create

  validates :user,             presence: true
  validates :payment_method,   presence: true, if: :committed?
  validates :billing_address,  presence: true, if: :committed?
  validates :shipping_address, presence: true, if: :committed?

  validates :committed, uniqueness: { scope: :user_id }, unless: :committed?
  validates :committed_at, presence: true, if: :committed?

  scope :committed, -> { where(committed: true) }
  scope :pending,   -> { where(committed: false) }

  delegate :currency, to: :payment_method, prefix: true

  def self.pending_purchase(user)
    where(user_id: user.id).pending.first_or_create
  end

  def add(item, currency, quantity=nil)
    if persisted? && pending?
      order = orders.kept.where(item_type: item.class, item_id: item.id).first_or_initialize
      order.currency   = currency
      order.quantity ||= 0
      quantity.present? ? 
        order.quantity  = quantity :
        order.quantity += 1
      order.save ? order : nil
    end
  end

  def remove(item)
    if persisted? && pending?
      order = 
        orders.kept.detect{ |o| o.item == item } || 
        orders.kept.detect{ |o| o      == item }
      order.present? && order.delete! ? order : nil
    end
  end

  def pending?
    !committed?
  end

  [:amount, :tax].each do |method|
    define_method method do |currency=payment_method_currency|
      orders.kept.reduce(BigDecimal("0.0")) { |s,o| s += Currency.exchange(o.send(method), o.currency, currency) } 
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
        # begin
          # ActiveRecord::Base.transaction do
            payment = create_payment!(
              attributes.symbolize_keys.slice(
                :user_id, 
                :payment_method_id, 
                :billing_address_id
              ).merge(
                amount: amount, 
                currency_id: payment_method_currency.id
              )
            )

            payment.commit! if orders.kept.all?{ |order| order.fulfill! }
          # end
          # true
        # rescue Fulfillment::FulfillmentFailure => ex
        #   false
        # end
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