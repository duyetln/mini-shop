class DigitalItem < ActiveRecord::Base
  include ItemResource

  def fulfill!(order)
    OnlineFulfillment.create(order_id: order.id).fulfill!
  end
end