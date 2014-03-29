require 'models/shared/item_resource'

class DigitalItem < ActiveRecord::Base
  include ItemResource

  def prepare!(order)
    OnlineFulfillment.prepare!(order, self)
  end
end
