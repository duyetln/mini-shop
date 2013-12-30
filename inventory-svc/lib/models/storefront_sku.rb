class StorefrontSku < ActiveRecord::Base
  include SkuResource

  SKU_TYPES = [ "BundleSku", "DigitalSku", "PhysicalSku" ]

  attr_accessible :sku_id, :sku_type

  belongs_to :sku, polymorphic: true

  validates :sku, presence: true
  validates :sku_type, inclusion: { in: SKU_TYPES }

  def available?
    !self.removed? && self.active? && self.sku.available?
  end

end