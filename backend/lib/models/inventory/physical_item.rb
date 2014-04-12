require 'models/shared/item_resource'

class PhysicalItem < ActiveRecord::Base
  include ItemResource
  include Quantifiable

  def available?
    super && qty > 0
  end

  def prepare!(order, qty)
    if self.qty >= qty
      self.qty -= qty
      save!
      ShippingFulfillment.add_or_update(self, qty: qty, conds: { order_id: order.id })
    end
  end
end
