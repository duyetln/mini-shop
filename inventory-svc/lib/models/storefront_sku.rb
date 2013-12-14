class StorefrontSku < ActiveRecord::Base
  include SharedSkuModel

  SKU_TYPES = [ "BundleSku", "DigitalSku", "PhysicalSku" ]

  belongs_to :sku, polymorphic: true

  validates :sku, presence: true
  validates :sku_type, inclusion: { in: SKU_TYPES.map(&:to_s) }

  def available?
    !self.deleted? && self.active? && self.sku.available?
  end

end