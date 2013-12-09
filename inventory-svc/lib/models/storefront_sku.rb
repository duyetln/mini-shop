class StorefrontSku < ActiveRecord::Base
  include SkuFeatures

  belongs_to :sku, polymorphic: true

  validates :sku,   presence: true

  def available?
    self.active? && self.sku.available?
  end

end