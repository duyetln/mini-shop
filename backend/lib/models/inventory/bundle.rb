require 'models/shared/item_resource'

class Bundle < ActiveRecord::Base
  include ItemResource

  has_many :bundleds

  after_save :reload

  def add_or_update(item, qty = 1, acc = false)
    if inactive? && kept?
      abundled = bundleds.add_or_update(item, qty: qty, acc: acc)
      reload && abundled
    end
  end

  def remove(item)
    if inactive? && kept?
      rbundled = bundleds.retrieve(item) do |bundled|
        bundled.destroy
      end
      reload && rbundled
    end
  end

  def items
    bundleds.map(&:item).compact
  end

  def available?
    super && items.present? && items.all?(&:available?)
  end

  def fulfill!(order, qty)
    items.all? { |item| item.fulfill!(order, qty * bundleds.retrieve(item).qty) }
  end

  def reverse!(order)
    items.all? { |item| item.reverse!(order) }
  end

  def activable?
    super && items.all?(&:active?)
  end
end
