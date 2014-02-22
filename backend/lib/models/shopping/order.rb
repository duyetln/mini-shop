class Order < ActiveRecord::Base

  include RemovableScope
  include Removable

  attr_accessible :item_type, :item_id, :currency_id, :quantity

  belongs_to :purchase
  belongs_to :item, polymorphic: :item
  belongs_to :currency

  validates :purchase_id, presence: true
  validates :item_type,   presence: true
  validates :item_id,     presence: true
  validates :currency_id, presence: true
  validates :quantity,    presence: true
  validates :quantity,    numericality: { greater_than_or_equal_to: 0 }

  validates :purchase_id, uniqueness: { scope: [ :item_type, :item_id ] }, unless: :removed?

  validates :purchase, presence: true
  validates :item,     presence: true
  validates :currency, presence: true

  validate  :pending_purchase

  before_create :set_uuid
  before_save   :set_values

  delegate :payment_method,   to: :purchase
  delegate :billing_address,  to: :purchase
  delegate :shipping_address, to: :purchase
  delegate :committed?,       to: :purchase, prefix: true
  delegate :pending?,         to: :purchase, prefix: true

  def delete!
    if persisted? && purchase_pending?
      self.removed = true
      save
    end
  end

  protected

  def pending_purchase
    errors.add(:purchase, "can't have committed status on save") unless purchase_pending?
  end

  def set_uuid
    self.uuid = SecureRandom.hex.upcase
  end

  def set_values
    self.amount = item.amount(currency) if currency_id_changed?
    self.tax_rate ||= ( 5 + rand(15) ) / 100.0
    self.tax = amount * quantity * tax_rate if amount_changed? || quantity_changed?
  end

end