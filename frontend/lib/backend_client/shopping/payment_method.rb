module BackendClient
  class PaymentMethod
    include APIResource
    include APIModel
    include DefaultUpdate

    def self.build_attributes(hash = {})
      super do |payment_method|
        payment_method.currency = Currency.instantiate(payment_method.currency)
        payment_method.balance = BigDecimal.new(payment_method.balance)
        payment_method.pending_balance = BigDecimal.new(payment_method.pending_balance)
        payment_method.billing_address = Address.instantiate(payment_method.billing_address)
      end
    end
  end
end
