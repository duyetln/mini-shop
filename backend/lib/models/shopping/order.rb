require "models/shared/enum"

class Order < ActiveRecord::Base

  include Enum

  enum :status, [ :prepared, :fulfilled, :reversed ]

  attr_accessible :item_type, :item_id, :currency_id, :quantity

  belongs_to :purchase
  belongs_to :item, polymorphic: :item
  belongs_to :currency
  has_many   :fulfillments

  validates :purchase, presence: true
  validates :item,     presence: true
  validates :currency, presence: true
  validates :quantity, presence: true

  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
  validates :purchase_id, uniqueness: { scope: [ :item_type, :item_id ] }, unless: :deleted?

  validate  :pending_purchase

  scope :deleted,  -> { where(deleted: true) }
  scope :kept,     -> { where(deleted: false) }

  before_create :set_uuid
  before_save   :set_values

  delegate :user,             to: :purchase
  delegate :payment_method,   to: :purchase
  delegate :billing_address,  to: :purchase
  delegate :shipping_address, to: :purchase
  delegate :committed?,       to: :purchase, prefix: true
  delegate :pending?,         to: :purchase, prefix: true

  def delete!
    if persisted? && !deleted? && purchase_pending?
      self.deleted = true
      save
    end
  end

  def prepare!
    if status.nil?
      begin
        self.class.transaction do
          quantity.times { 
            item.prepare!(self) 
          } || ( 
            raise Fulfillment::PreparationFailure 
          )
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
          fulfillments.all? { |f| 
            f.fulfill! 
          } || ( 
            raise Fulfillment::FulfillmentFailure 
          )
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
          fulfillments.all? { |f| 
            f.reverse! 
          } || ( 
            raise Fulfillment::ReversalFailure 
          )
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

  def kept?
    !deleted?
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

  def set_uuid
    self.uuid = SecureRandom.hex.upcase
  end

  def set_values
    self.amount = item.amount(currency) * quantity if currency_id_changed? || quantity_changed?
    self.tax_rate ||= ( 5 + rand(15) ) / 100.0
    self.tax = amount * tax_rate if amount_changed?
  end

end