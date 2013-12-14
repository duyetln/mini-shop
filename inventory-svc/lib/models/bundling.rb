class Bundling < ActiveRecord::Base

  BUNDLED_SKU_TYPES = [ "DigitalSku", "PhysicalSku" ]

  belongs_to :bundle_sku
  belongs_to :bundled_sku, polymorphic: true

  validates :bundle_sku,  presence: true
  validates :bundled_sku, presence: true
  validates :bundle_sku_id,   uniqueness: { scope: [ :bundled_sku_id, :bundled_sku_type ] }
  validates :bundle_sku_type, inclusion:  { in: BUNDLED_SKU_TYPES.map(&:to_s) }

end