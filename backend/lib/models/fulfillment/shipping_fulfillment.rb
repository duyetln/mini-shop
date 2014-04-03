class ShippingFulfillment < Fulfillment
  protected

  def process_fulfillment!
    Shipment.add_or_update(item, conds: { order_id: order.id }) do |shipment|
      shipment.user = order.user
      shipment.shipping_address = order.shipping_address
    end
  end
end
