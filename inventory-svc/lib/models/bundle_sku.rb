class BundleSku < ActiveRecord::Base
  include SharedSkuModel

  has_many  :bundlings
  has_many  :physical_skus, through: :bundlings, source: :bundled_sku, source_type: "PhysicalSku"
  has_many  :digital_skus,  through: :bundlings, source: :bundled_sku, source_type: "DigitalSku"

  def bundled_skus
    self.physical_skus + self.digital_skus
  end

  def available?
    !self.deleted? && self.active? && self.bundled_skus.present? && self.bundled_skus.all?{ |s| s.available? }
  end

end