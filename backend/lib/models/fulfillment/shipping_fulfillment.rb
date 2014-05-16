class ShippingFulfillment < Fulfillment
  validates :item_type, inclusion: { in: %w{ PhysicalItem } }

  protected

  def process_fulfillment!
    Shipment.create!(
      item: item,
      qty: qty,
      order: order,
      user: order.user,
      shipping_address: order.shipping_address
    )
  end

  def process_reversal!
    # do nothing
    true
  end
end
