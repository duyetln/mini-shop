require 'models/shared/item_combinable'
require 'models/shared/status'

class Order < ActiveRecord::Base
  STATUS = { failed: -2, invalid: -1, fulfilled: 1, reversed: 2 }

  include ItemCombinable
  include Deletable
  include Status::Mixin

  attr_protected :uuid, :purchase_id
  attr_readonly :uuid, :purchase_id

  belongs_to :purchase, inverse_of: :orders
  belongs_to :currency
  belongs_to :refund_transaction, class_name: 'RefundTransaction'
  has_many :fulfillments, inverse_of: :order

  validates :purchase, presence: true
  validates :currency, presence: true
  validates :amount,   presence: true

  validates :purchase_id, uniqueness: { scope: [:item_type, :item_id, :deleted] }, unless: :deleted?
  validates :uuid, uniqueness: true
  validates :item_type, inclusion: { in: %w(Coupon Bundle DigitalItem PhysicalItem) }

  validate :pending_purchase

  after_initialize :initialize_values
  before_save :update_amount_and_tax

  delegate :user,                 to: :purchase
  delegate :payment_method,       to: :purchase
  delegate :shipping_address,     to: :purchase
  delegate :committed?,           to: :purchase, prefix: true
  delegate :pending?,             to: :purchase, prefix: true
  delegate :paid?,                to: :purchase, prefix: true
  delegate :free?,                to: :purchase, prefix: true
  delegate :payment_transaction,  to: :purchase, prefix: true

  def deletable?
    purchase_pending? && super
  end

  def fulfillable?
    purchase_committed? && unmarked? && item.active? && item.available?
  end

  def fulfill!
    if fulfillable?
      begin
        self.class.transaction do
          unless  item.fulfill!(self, qty) &&
                  fulfillments.all? { |f| f.fulfill! }
            fail Fulfillment::FulfillmentFailure
          end
          mark_fulfilled!
        end
      rescue => ex
        refund!
        mark_failed!
      end
      reload
      fulfilled?
    end
  end

  def reversible?
    purchase_committed? && fulfilled? && item.active?
  end

  def reverse!
    if reversible?
      begin
        self.class.transaction do
          unless  item.reverse!(self) &&
                  fulfillments.all? { |f| f.reverse! }
            fail Fulfillment::ReversalFailure
          end
          refund!
          mark_reversed!
        end
      rescue
        mark_failed!
      end
      reload
      reversed?
    end
  end

  def total
    if amount && tax
      amount + tax
    end
  end

  protected

  def update_amount_and_tax
    if currency_id_changed? && currency_id_was.present?
      self.amount = Currency.exchange(
        amount,
        Currency.find(currency_id_was),
        Currency.find(currency_id)
      )
    end
    self.tax_rate ||= ((5 + rand(15)) / 100.0).round(2)
    self.tax = amount * tax_rate
  end

  def pending_purchase
    if changed? && purchase.present? && purchase_committed?
      errors.add(:purchase, 'cannot be already commited on save')
    end
  end

  def initialize_values
    if new_record?
      self.uuid = SecureRandom.hex(4).upcase
    end
  end

  private

  def refund!
    if purchase_committed?
      if refund_transaction.blank? && purchase_paid? && total > 0
        build_refund_transaction
        refund_transaction.user = user
        refund_transaction.amount = total
        refund_transaction.currency = currency
        refund_transaction.payment_method = payment_method
        refund_transaction.save!
        save!
      end
      refund_transaction
    end
  end
end
