require 'models/shared/committable'

class Purchase < ActiveRecord::Base
  include Committable

  attr_readonly :user_id

  has_many :orders, inverse_of: :purchase
  has_many :refunds, through: :orders

  belongs_to :payment_method
  belongs_to :billing_address,  class_name: 'Address'
  belongs_to :shipping_address, class_name: 'Address'
  belongs_to :payment, class_name: 'PaymentTransaction'
  belongs_to :user, inverse_of: :purchases

  validates :user,             presence: true
  validates :payment_method,   presence: true, if: :committed?
  validates :billing_address,  presence: true, if: :committed?
  validates :shipping_address, presence: true, if: :committed?

  validate :pending

  delegate :currency, to: :payment_method, prefix: true, allow_nil: true

  scope :current, -> user { pending.where(user_id: user.id) }

  after_save :reload

  def add_or_update(item, amount, currency, qty = 1)
    if changeable?
      aorder = orders.add_or_update(item, qty: qty, acc: false) do |order|
        order.amount = amount
        order.currency = currency
        order.save!
      end
      reload && aorder
    end
  end

  def remove(item)
    if changeable?
      rorder = orders.retrieve(item) do |order|
        order.delete!
      end
      reload && rorder
    end
  end

  def changeable?
    pending?
  end

  [:amount, :tax, :total].each do |method|
    define_method method do |currency = payment_method_currency|
      orders.reduce(BigDecimal('0.0')) do |a, e|
        a + Currency.exchange(e.send(method), e.currency, currency)
      end
    end
  end

  def fulfillable?
    committed? && (free? || paid?)
  end

  def fulfill!
    if fulfillable?
      orders.each do |order|
        order.fulfill!
      end
      transactions.each do |transaction|
        transaction.commit!
      end
      reload
    end
  end

  def reversible?
    committed?
  end

  def reverse!(*items)
    if reversible?
      reversals = if items.present?
                    items.map do |item|
                      orders.retrieve(item)
                    end.compact
                  else
                    orders
                  end
      reversals.each do |order|
        order.reverse!
      end
      transactions.each do |transaction|
        transaction.commit!
      end
      reload
    end
  end

  def transactions
    (refunds + [payment]).compact
  end

  def commit!
    save!
    normalize!
    super
  end

  def normalize!
    if payment_method.present?
      orders.each do |order|
        order.currency = payment_method_currency
        order.save!
      end
    end
  end

  def free?
    total <= 0
  end

  def paid?
    payment.present?
  end

  def pay!
    if committed?
      if !free? && !paid? && payment_method.enough?(total)
        build_payment
        payment.user = user
        payment.amount = total
        payment.currency = payment_method_currency
        payment.payment_method = payment_method
        payment.billing_address = billing_address
        payment.save!
        save!
      end
      payment
    end
  end

  protected

  def pending
    if persisted? && committed? && changes.except(:committed, :committed_at).present?
      errors.add(:purchase, 'cannot be changed after committed')
    end
  end
end
