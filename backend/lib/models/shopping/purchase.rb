class Purchase < ActiveRecord::Base

  attr_accessible :user_id, :payment_method_id, :billing_address_id, :shipping_address_id

  has_many :orders

  belongs_to :payment_method
  belongs_to :billing_address,  class_name: Address
  belongs_to :shipping_address, class_name: Address
  belongs_to :payment

  before_validation :set_values, on: :create

  validates :submitted, uniqueness: { scope: :user_id }, unless: :submitted?
  validates :submitted_at, presence: true, if: :submitted?

  validates :user_id,             presence: true 
  validates :payment_method_id,   presence: true, if: :submitted?
  validates :billing_address_id,  presence: true, if: :submitted?
  validates :shipping_address_id, presence: true, if: :submitted?

  validates :user,             presence: true
  validates :payment_method,   presence: true, if: :submitted?
  validates :billing_address,  presence: true, if: :submitted?
  validates :shipping_address, presence: true, if: :submitted?

  scope :submitted, -> { where(submitted: true) }
  scope :pending,   -> { where(submitted: false) }

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
    if pending?
      order = orders.kept.where(item_type: item_type, item_id: item_id).first_or_initialize
      order.currency_id = currency_id
      order.quantity    = quantity
      order.save ? order : nil
    end
  end

  def remove_order(order_id)
    if pending?
      order = orders.kept.find_by_id(order_id) || orders.kept.find_by_uuid(order_id)
      order.present? && order.delete! ? order : nil
    end
  end

  def pending?
    !submitted?
  end

  [:amount, :tax].each do |method|
    define_method method do
      orders.kept.reduce(BigDecimal.new("0")) { |sum,order| sum += order.send(method) }
    end
  end

  # stubbed
  def user
    true
  end

  def submit!
    if persisted?
      self.submitted    = true
      self.submitted_at = DateTime.now
      save
    end
  end

  def fulfill!
    if persisted? && submitted?

    end
  end

  protected

  def set_values
    self.submitted    = false
    self.submitted_at = nil
    true
  end
end