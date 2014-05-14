require 'models/shared/item_combinable'

class Bundled < ActiveRecord::Base
  include ItemCombinable

  attr_readonly :bundle_id

  belongs_to :bundle

  validates :bundle, presence: true

  validates :bundle_id, uniqueness: { scope: [:item_type, :item_id] }
  validates :item_type, inclusion: { in: %w{ DigitalItem PhysicalItem } }
end
