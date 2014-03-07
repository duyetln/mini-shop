require "models/shared/item_resource"
require "models/shared/orderable"

class StorefrontItem < ActiveRecord::Base

  include ItemResource
  include Orderable

  attr_accessible :item_id, :item_type, :price_id

  belongs_to :item, polymorphic: true
  belongs_to :price

  validates :price, presence: true
  validates :item,  presence: true
  validates :item_type, inclusion: { in: %w{ BundleItem DigitalItem PhysicalItem } }

  delegate :amount, to: :price
  delegate :discounted?, to: :price
  delegate :prepare!, to: :item

  def available?
    super && item.available?
  end

end