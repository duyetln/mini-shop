class Order < ActiveRecord::Base

  include RemovableScope
  include Removable

  attr_accessible :item_type, :item_id, :currency_id, :quantity

  belongs_to :purchase
  belongs_to :item, polymorphic: :sku
  belongs_to :currency

  validates :purchase_id, presence: true
  validates :item_type,   presence: true
  validates :item_id,     presence: true
  validates :currency_id, presence: true
  validates :quantity,    presence: true
  validates :quantity,    numericality: { greater_than_or_equal_to: 0 }

  validates :purchase_id, uniqueness: { scope: [ :item_type, :item_id, :currency_id] }, unless: :removed?

  validates :purchase, presence: true
  validates :item,     presence: true
  validates :currency, presence: true

  before_create :set_values

  delegate :payment_method,   to: :purchase
  delegate :billing_address,  to: :purchase
  delegate :shipping_address, to: :purchase

  def delete!
    if persisted? && purchase.pending?
      self.removed = true
      save
    end
  end

  protected

  def set_values
    self.uuid = SecureRandom.hex.upcase
    #set amount
  end

end