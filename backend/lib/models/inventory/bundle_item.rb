require 'models/shared/item_resource'

class BundleItem < ActiveRecord::Base
  include ItemResource

  has_many :bundlings, foreign_key: :bundle_id

  def add_or_update(item, qty = 1, acc = true)
    if kept?
      bundling = bundlings.add_or_update(item, qty: qty, acc: acc)
      reload && bundling
    end
  end

  def remove(item)
    if kept?
      bundling = bundlings.retrieve(item) do |bnln|
        bnln.destroy
      end
      reload && bundling
    end
  end

  def items
    bundlings.map(&:item)
  end

  def available?
    super && items.present? && items.all?(&:available?)
  end

  def prepare!(order, qty)
    bundlings.all? { |bundling| bundling.item.prepare!(order, qty * bundling.qty) }
  end
end
