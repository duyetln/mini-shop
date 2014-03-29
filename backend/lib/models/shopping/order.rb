require 'models/shared/enum'
require 'models/shared/item_combinable'

class Order < ActiveRecord::Base
  include Enum
  include ItemCombinable
  include Deletable

  enum :status, [:prepared, :fulfilled, :reversed]

  attr_protected :uuid, :purchase_id, :status, :fulfilled_at, :reversed_at
  attr_readonly :uuid, :purchase_id

  belongs_to :purchase
  belongs_to :currency
  has_many   :fulfillments

  validates :purchase, presence: true
  validates :currency, presence: true

  validates :purchase_id, uniqueness: { scope: [:item_type, :item_id] }, unless: :deleted?

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
    if status.nil?
      begin
        self.class.transaction do
          qty.times { item.prepare!(self) } || (fail Fulfillment::PreparationFailure)
          self.status = STATUS[:prepared]
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
          self.status = STATUS[:fulfilled]
          self.fulfilled_at = DateTime.now
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
          self.status = STATUS[:reversed]
          self.reversed_at = DateTime.now
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
    if !status_changed? &&
      !fulfilled_at_changed? &&
      !reversed_at_changed? &&
      changed?
      errors.add(:purchase, "can't be already commited on save") unless purchase_pending?
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
