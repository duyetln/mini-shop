class BundleItem < ActiveRecord::Base
  include ItemResource

  has_many :bundlings
  has_many :physical_items, through: :bundlings, source: :bundled_item, source_type: "PhysicalItem"
  has_many :digital_items,  through: :bundlings, source: :bundled_item, source_type: "DigitalItem"

  def bundled_items
    physical_items + digital_items
  end

  def available?
    !deleted? && active? && bundled_items.present? && bundled_items.all?(&:available?)
  end

  def prepare!(order)
    bundled_items.all?{ |item| item.prepare!(order) }
  end

end