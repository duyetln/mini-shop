class Purchase < ServiceResource
  extend DefaultFind
  include DefaultUpdate

  def self.instantiate(hash = {})
    super do |purchase|
      purchase.payment_method = PaymentMethod.instantiate(purchase.payment_method)
      purchase.billing_address = Address.instantiate(purchase.billing_address)
      purchase.shipping_address = Address.instantiate(purchase.shipping_address)
      purchase.payment = Transaction.instantiate(purchase.payment)
      purchase.orders.map! { |order| Order.instantiate(order) }
    end
  end
end
