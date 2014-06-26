class PaymentMethod < ServiceResource
  include DefaultUpdate

  def self.instantiate(hash = {})
    super do |payment_method|
      payment_method.balance = BigDecimal.new(payment_method.balance)
    end
  end
end
