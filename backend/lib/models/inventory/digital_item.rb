class DigitalItem < ActiveRecord::Base
  include ItemResource

  def fulfill!(order)
    fulfillment = OnlineFulfillment.new
    fulfillment.order = order
    fulfillment.item  = self
    fulfillment.save!
    fulfillment.fulfill!
  end
end