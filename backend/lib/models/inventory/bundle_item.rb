require 'models/shared/item_resource'

class BundleItem < ActiveRecord::Base
  include ItemResource

  has_many :bundlings, foreign_key: :bundle_id

  after_save :reload

  def add_or_update(item, qty = 1, acc = true)
    if kept?
      abundling = bundlings.add_or_update(item, qty: qty, acc: acc)
      reload && abundling
    end
  end

  def remove(item)
    if kept?
      rbundling = bundlings.retrieve(item) do |bundling|
        bundling.destroy
      end
      reload && rbundling
    end
  end

  def items
    bundlings.map(&:item).compact
  end

  def available?
    super && items.present? && items.all?(&:available?)
  end

  def prepare!(order, qty)
    bundlings.all? { |bundling| bundling.item.prepare!(order, qty * bundling.qty) }
  end
end
