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
  belongs_to :user
  has_many   :transactions, as: :source, class_name: 'Transaction'

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
    if committed? && unmarked?
      orders.each do |order|
        order.prepare!
      end
      mark_prepared!
      prepared?
    end
  end

  def fulfill!
    if committed? && prepared?
      if payment_method.enough?(amount)
        create_transaction!.commit!
        orders.each do |order|
          if order.fulfill! == false
            create_transaction!(
             -order.amount,
              order.currency
            ).commit!
          end
        end
        mark_fulfilled!
        fulfilled?
      end
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

  private

  def create_transaction!(input_amount = amount, input_currency = payment_method_currency)
    if committed?
      transaction = transactions.build
      transaction.user = user
      transaction.amount = input_amount
      transaction.currency = input_currency
      transaction.payment_method = payment_method
      transaction.billing_address = billing_address
      transaction.save!
      transaction
    end
  end
end
