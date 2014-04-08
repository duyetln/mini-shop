require 'models/shared/item_combinable'
require 'models/shared/status'

class Order < ActiveRecord::Base
  STATUS = { prepared: 0, fulfilled: 1, reversed: 2 }

  include ItemCombinable
  include Deletable
  include Status::Mixin

  attr_protected :uuid, :purchase_id
  attr_readonly :uuid, :purchase_id

  belongs_to :purchase
  belongs_to :currency
  has_many   :fulfillments

  validates :purchase, presence: true
  validates :currency, presence: true

  validates :purchase_id, uniqueness: { scope: [:item_type, :item_id] }, unless: :deleted?
  validates :item_type, inclusion: { in: %w{ StorefrontItem } }

  validate  :pending_purchase

  after_initialize :initialize_values
  before_save :set_values

  delegate :user,             to: :purchase
  delegate :payment_method,   to: :purchase
  delegate :billing_address,  to: :purchase
  delegate :shipping_address, to: :purchase
  delegate :committed?,       to: :purchase, prefix: true
  delegate :pending?,         to: :purchase, prefix: true

  def delete!
    if purchase_pending?
      super
    end
  end

  def prepare!
    unless marked?
      begin
        self.class.transaction do
          item.prepare!(self, qty) &&
            fulfillments.all? { |f| f.prepare! } ||
            (fail Fulfillment::PreparationFailure)
          mark_prepared!
          save!
        end
      rescue => err
        puts err.message
        puts err.backtrace.inspect
      end
    end
  end

  def fulfill!
    if prepared?
      begin
        self.class.transaction do
          fulfillments.all? { |f| f.fulfill! } || (fail Fulfillment::FulfillmentFailure)
          mark_fulfilled!
          save!
        end
      rescue => err
        puts err.message
        puts err.backtrace.inspect
      end
    end
  end

  def reverse!
    if fulfilled?
      begin
        self.class.transaction do
          fulfillments.all? { |f| f.reverse! } || (fail Fulfillment::ReversalFailure)
          mark_reversed!
          save!
        end
      rescue => err
        puts err.message
        puts err.backtrace.inspect
      end
    end
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

  def set_values
    self.amount = item.amount(currency) * qty if currency_id_changed? || qty_changed?
    self.tax_rate ||= (5 + rand(15)) / 100.0
    self.tax = amount * tax_rate if amount_changed?
  end
end
