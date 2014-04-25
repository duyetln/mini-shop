require 'models/shared/item_resource'

class PhysicalItem < ActiveRecord::Base
  include ItemResource
  include Quantifiable

  def available?
    super && qty > 0
  end

  def prepare!(order, qty)
    ShippingFulfillment.create!(item: self, order: order, qty: qty)
  end
end
