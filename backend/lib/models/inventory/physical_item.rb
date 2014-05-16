require 'models/shared/item_resource'

class PhysicalItem < ActiveRecord::Base
  include ItemResource
  include Quantifiable

  def available?
    super && qty > 0
  end

  def fulfill!(order, qty)
    if self.qty >= qty
      self.qty -= qty
      save!
      ShippingFulfillment.create!(item: self, order: order, qty: qty)
    end
  end

  def reverse!(order)
    self.qty += ShippingFulfillment.where(
      item_type: self.class,
      item_id: id,
      order_id: order.id
    ).sum(:qty)
    save!
  end
end
