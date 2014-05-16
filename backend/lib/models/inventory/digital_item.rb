require 'models/shared/item_resource'

class DigitalItem < ActiveRecord::Base
  include ItemResource

  def fulfill!(order, qty)
    OnlineFulfillment.create!(item: self, order: order, qty: qty)
  end

  def reverse!(order)
    # do nothing
    true
  end
end
