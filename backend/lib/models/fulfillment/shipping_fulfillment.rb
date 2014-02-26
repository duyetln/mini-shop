class ShippingFulfillment < Fulfillment

  protected

  def process!
    shipment = Shipment.new
    shipment.user = order.user
    shipment.item = order.item
    shipment.shipping_address = order.shipping_address
    shipment.save!
  end
end