class StorefrontItem < ActiveRecord::Base
  include ItemResource

  ITEM_TYPES = [ "BundleItem", "DigitalItem", "PhysicalItem" ]

  attr_accessible :item_id, :item_type, :price_id

  belongs_to :item, polymorphic: true
  belongs_to :price

  validates :price, presence: true
  validates :item,  presence: true
  validates :item_type, inclusion: { in: ITEM_TYPES }

  delegate :amount, to: :price
  delegate :discounted?, to: :price

  def available?
    !removed? && active? && item.available?
  end

end