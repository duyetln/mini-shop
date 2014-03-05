class Bundling < ActiveRecord::Base

  belongs_to :bundle_item
  belongs_to :bundled_item, polymorphic: true

  validates :bundle_item, presence: true
  validates :bundled_item, presence: true
  validates :quantity, presence: true

  validates :bundle_item_id, uniqueness: { scope: [ :bundled_item_id, :bundled_item_type ] }
  validates :bundled_item_type, inclusion: { in: [ "DigitalItem", "PhysicalItem" ] }
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }

end