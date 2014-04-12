class ShippingFulfillment < Fulfillment
  validates :item_type, inclusion: { in: %w{ PhysicalItem } }

  protected

  def process_fulfillment!
    Shipment.add_or_update(item, qty: qty, conds: { order_id: order.id }) do |shipment|
      shipment.user = order.user
      shipment.shipping_address = order.shipping_address
    end
  end
end
