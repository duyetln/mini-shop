require "models/shared/item_combinable"

class Bundling < ActiveRecord::Base
  
  include ItemCombinable

  belongs_to :bundle, class_name: "BundleItem"

  validates :bundle, presence: true

  validates :bundle_id, uniqueness: { scope: [ :item_id, :item_type ] }
  validates :item_type, inclusion: { in: %w{ DigitalItem PhysicalItem } }

end