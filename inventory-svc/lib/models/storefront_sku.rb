class StorefrontSku < ActiveRecord::Base
  include SharedSkuModel

  belongs_to :sku, polymorphic: true

  validates :sku, presence: true

  def available?
    !self.deleted? && self.active? && self.sku.available?
  end

end