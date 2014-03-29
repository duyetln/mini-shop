require 'models/shared/item_resource'

class PhysicalItem < ActiveRecord::Base

  include ItemResource
  include Quantifiable

  def available?
    super && quantity > 0
  end

  def prepare!(order)
    ShippingFulfillment.prepare!(order, self)
  end

end