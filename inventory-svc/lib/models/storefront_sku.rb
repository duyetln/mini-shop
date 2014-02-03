class StorefrontSku < ActiveRecord::Base
  include SkuResource

  SKU_TYPES = [ "BundleSku", "DigitalSku", "PhysicalSku" ]

  attr_accessible :sku_id, :sku_type, :price_id

  belongs_to :sku, polymorphic: true
  belongs_to :price

  validates :price, presence: true
  validates :sku,   presence: true
  validates :sku_type, inclusion: { in: SKU_TYPES }

  delegate :amount, to: :price

  def available?
    !self.removed? && self.active? && self.sku.available?
  end

end