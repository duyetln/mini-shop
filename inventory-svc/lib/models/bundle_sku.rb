class BundleSku < ActiveRecord::Base
  include SkuResource

  has_many :bundlings
  has_many :physical_skus, through: :bundlings, source: :bundled_sku, source_type: "PhysicalSku"
  has_many :digital_skus,  through: :bundlings, source: :bundled_sku, source_type: "DigitalSku"

  def bundled_skus
    physical_skus + digital_skus
  end

  def available?
    !removed? && active? && bundled_skus.present? && bundled_skus.all?(&:available?)
  end

end