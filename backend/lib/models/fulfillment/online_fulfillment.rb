class OnlineFulfillment < Fulfillment
  validates :item_type, inclusion: { in: %w{ DigitalItem } }

  protected

  def process_fulfillment!
    Ownership.add_or_update(item, qty: qty, conds: { order_id: order.id }) do |ownership|
      ownership.user = order.user
    end
  end
end
