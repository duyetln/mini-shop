class OnlineFulfillment < Fulfillment
  validates :item_type, inclusion: { in: %w{ DigitalItem } }

  protected

  def process_fulfillment!
    Ownership.create!(
      item: item,
      qty: qty,
      order: order,
      user: order.user
    )
  end
end
