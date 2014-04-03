require 'models/shared/committable'

class Purchase < ActiveRecord::Base
  include Committable

  attr_readonly :user_id

  has_many :orders

  belongs_to :payment_method
  belongs_to :billing_address,  class_name: 'Address'
  belongs_to :shipping_address, class_name: 'Address'
  belongs_to :payment
  belongs_to :user

  validates :user,             presence: true
  validates :payment_method,   presence: true, if: :committed?
  validates :billing_address,  presence: true, if: :committed?
  validates :shipping_address, presence: true, if: :committed?

  validates :committed, uniqueness: { scope: :user_id }, unless: :committed?

  delegate :currency, to: :payment_method, prefix: true, allow_nil: true

  def self.pending_purchase(user)
    where(user_id: user.id).pending.first_or_create
  end

  def add_or_update(item, currency, qty = 1)
    orders.add_or_update(item, qty: qty, acc: false) { |order| order.currency = currency } if pending?
  end

  def remove(item)
    orders.retrieve(item) { |order| order.delete! } if pending?
  end

  [:amount, :tax].each do |method|
    define_method method do |currency = payment_method_currency|
      orders.reduce(BigDecimal('0.0')) do |a, e| 
        a += Currency.exchange(
          e.send(method), 
          e.currency, 
          currency
        )
      end
    end
  end

  def prepare!
    if persisted? && committed?
      orders.all? { |order| order.prepare! }
    end
  end

  def fulfill!
    if persisted? && committed?
      if payment_method.enough?(amount)
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

        payment.commit! if orders.all? { |order| order.fulfill! }
      end
    end
  end

  def reverse!
  end
end
