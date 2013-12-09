class Bundling < ActiveRecord::Base

  belongs_to :bundle_sku
  belongs_to :bundled_sku, polymorphic: true

  validates :bundle_sku,  presence: true
  validates :bundled_sku, presence: true
  validates :bundle_sku_id, uniqueness: { scope: [ :bundled_sku_id, :bundled_sku_type ] }

end