require 'models/shared/committable'

class Purchase < ActiveRecord::Base
  STATUS = { prepared: 0, fulfilled: 1, reversed: 2 }

  include Committable
  include Status::Mixin

  attr_readonly :user_id

  has_many :orders

  belongs_to :payment_method
  belongs_to :billing_address,  class_name: 'Address'
  belongs_to :shipping_address, class_name: 'Address'
  belongs_to :payment, class_name: 'Transaction'
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

  def commit!
    normalize!
    super
  end

  def total(currency = payment_method_currency)
    amount(currency) + tax(currency)
  end

  def prepare!
    if committed? && unmarked?
      if payment_method.enough?(total)
        make_payment!
        orders.each do |order|
          order.prepare!
        end
        mark_prepared!
        prepared?
      end
    end
  end

  def fulfill!
    if committed? && prepared?
      orders.each do |order|
        order.fulfill!
      end
      transactions.each do |transaction|
        transaction.commit!
      end
      mark_fulfilled!
      fulfilled?
    end
  end

  def reverse!
    if committed? && fulfilled?
      orders.each do |order|
        order.reverse!
      end
      mark_reversed!
      reversed?
    end
  end

  def transactions
    [] + orders.map(&:refund) << payment
  end

  def normalize!
    if payment_method.present?
      orders.each do |order|
        order.currency = payment_method_currency
        order.update_values
        order.save!
      end
    end
  end

  private

  def make_payment!
    if committed?
      unless payment.present?
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
end
