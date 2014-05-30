require 'models/shared/item_combinable'
require 'models/shared/status'

class Order < ActiveRecord::Base
  STATUS = { failed: -2, invalid: -1, fulfilled: 1, reversed: 2 }

  include ItemCombinable
  include Deletable
  include Status::Mixin

  attr_protected :uuid, :purchase_id
  attr_readonly :uuid, :purchase_id

  belongs_to :purchase
  belongs_to :currency
  belongs_to :refund, class_name: 'Transaction'
  has_many   :fulfillments

  validates :purchase, presence: true
  validates :currency, presence: true

  validates :purchase_id, uniqueness: { scope: [:item_type, :item_id, :deleted] }, unless: :deleted?
  validates :uuid, uniqueness: true
  validates :item_type, inclusion: { in: %w{ StoreItem } }

  validate  :pending_purchase

  after_initialize :initialize_values

  delegate :user,             to: :purchase
  delegate :payment_method,   to: :purchase
  delegate :billing_address,  to: :purchase
  delegate :shipping_address, to: :purchase
  delegate :committed?,       to: :purchase, prefix: true
  delegate :pending?,         to: :purchase, prefix: true
  delegate :paid?,            to: :purchase, prefix: true
  delegate :payment,          to: :purchase, prefix: true

  def deletable?
    purchase_pending? && super
  end

  def fulfillable?
    purchase_committed? && unmarked?
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
      rescue
        make_refund!
        mark_failed!
      end
      reload
      fulfilled?
    end
  end

  def reversible?
    purchase_committed? && fulfilled?
  end

  def reverse!
    if reversible?
      begin
        self.class.transaction do
          unless  item.reverse!(self) &&
                  fulfillments.all? { |f| f.reverse! }
            fail Fulfillment::ReversalFailure
          end
          make_refund!
          mark_reversed!
        end
      rescue
        mark_failed!
      end
      reload
      reversed?
    end
  end

  def amount!(input_currency = currency)
    self.currency = input_currency
    self.amount = item.amount(input_currency) * qty
    save!
  end

  def tax!
    self.tax_rate ||= (5 + rand(15)) / 100.0
    self.tax = amount * tax_rate
    save!
  end

  def amount(input_currency = currency)
    Currency.exchange(super() || 0, currency, input_currency)
  end

  def tax(input_currency = currency)
    Currency.exchange(super() || 0, currency, input_currency)
  end

  def total(input_currency = currency)
    amount(input_currency) + tax(input_currency)
  end

  protected

  def pending_purchase
    if changed? && purchase.present? && purchase_committed?
      errors.add(:purchase, 'cannot be already commited on save')
    end
  end

  def initialize_values
    if new_record?
      self.uuid = SecureRandom.hex.upcase
    end
  end

  private

  def make_refund!
    if purchase_committed?
      if refund.blank? && purchase_paid? && total > 0
        build_refund
        refund.user = user
        refund.amount = -total
        refund.currency = currency
        refund.payment_method = payment_method
        refund.billing_address = billing_address
        refund.save!
        save!
      end
      refund
    end
  end
end
