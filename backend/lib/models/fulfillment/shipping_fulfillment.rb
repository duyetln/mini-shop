class ShippingFulfillment < Fulfillment
  validates :item_type, inclusion: { in: %w{ PhysicalItem } }

  protected

  def process_fulfillment!
    if item.qty >= qty
      item.qty -= qty
      item.save!
      Shipment.create!(
        item: item,
        qty: qty,
        order: order,
        user: order.user,
        shipping_address: order.shipping_address
      )
    end
  end

  def process_reversal!
    item.qty += qty
    item.save!
  end
end
