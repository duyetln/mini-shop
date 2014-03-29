class OnlineFulfillment < Fulfillment
  protected

  def process_fulfillment!
    ownership = Ownership.where(
      order_id: order.id,
      item_type: item.class,
      item_id: item.id
    ).first_or_initialize

    ownership.user = order.user
    ownership.quantity ||= 0
    ownership.quantity  += 1
    ownership.save!
  end
end
