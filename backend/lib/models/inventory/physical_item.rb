class PhysicalItem < ActiveRecord::Base
  include ItemResource

  attr_accessible :quantity

  validates :quantity, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }

  def available?
    !deleted? && active? && quantity > 0
  end

  def fulfill!(order)
    fulfillment = ShippingFulfillment.new
    fulfillment.order = order
    fulfillment.item  = self
    fulfillment.save!
    fulfillment.fufill!
  end

end