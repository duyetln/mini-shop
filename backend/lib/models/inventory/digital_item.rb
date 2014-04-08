require 'models/shared/item_resource'

class DigitalItem < ActiveRecord::Base
  include ItemResource

  def prepare!(order, qty)
    OnlineFulfillment.add_or_update(self, qty: qty, conds: { order_id: order.id })
  end
end
