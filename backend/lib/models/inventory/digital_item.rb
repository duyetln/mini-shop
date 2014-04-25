require 'models/shared/item_resource'

class DigitalItem < ActiveRecord::Base
  include ItemResource

  def prepare!(order, qty)
    OnlineFulfillment.create!(item: self, order: order, qty: qty)
  end
end
