require 'models/shared/item_resource'

class DigitalItem < ActiveRecord::Base
  include ItemResource

  def prepare!(order, qty)
    order.fulfillments << OnlineFulfillment.new(item: self, qty: qty)
  end
end
