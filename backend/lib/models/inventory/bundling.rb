require "models/shared/itemable"

class Bundling < ActiveRecord::Base
  
  include Itemable

  belongs_to :bundle, class_name: "BundleItem"
  belongs_to :item, polymorphic: true

  validates :bundle, presence: true
  validates :item, presence: true
  validates :quantity, presence: true

  validates :bundle_id, uniqueness: { scope: [ :item_id, :item_type ] }
  validates :item_type, inclusion: { in: %w{ DigitalItem PhysicalItem } }
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }

end