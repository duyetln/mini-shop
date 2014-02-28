class DigitalItem < ActiveRecord::Base
  include ItemResource

  def prepare!(order)
    fulfillment = OnlineFulfillment.new
    fulfillment.order = order
    fulfillment.item  = self
    fulfillment.save!
  end
end