class OnlineFulfillment < Fulfillment

  protected

  def process!
    ownership = Ownership.new
    ownership.user = order.user
    ownership.item = order.item
    ownership.save
  end
end