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

  def process_reversal!
    Ownership.where(
      item_type: item.class,
      item_id: item.id,
      order_id: order.id
    ).each do |ownership|
      ownership.delete!
    end
  end
end
