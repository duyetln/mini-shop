class Bundling < ActiveRecord::Base

  BUNDLED_ITEM_TYPES = [ "DigitalItem", "PhysicalItem" ]

  belongs_to :bundle_item
  belongs_to :bundled_item, polymorphic: true

  validates :bundle_item,    presence: true
  validates :bundle_item_id, uniqueness: { scope: [ :bundled_item_id, :bundled_item_type ] }
  validates :bundled_item,      presence: true
  validates :bundled_item_type, inclusion: { in: BUNDLED_ITEM_TYPES }

end