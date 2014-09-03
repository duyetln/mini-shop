module BackendClient
  class Transaction
    include APIModel

    def self.build_attributes(hash = {})
      super do |transaction|
        transaction.payment_method = PaymentMethod.instantiate(transaction.payment_method)
        transaction.billing_address = Address.instantiate(transaction.billing_address)
        transaction.amount = BigDecimal.new(transaction.amount)
        transaction.currency = Currency.instantiate(transaction.currency)
        transaction.committed_at = DateTime.parse(transaction.committed_at) if transaction.committed_at.present?
      end
    end

    def user
      User.find(user_id)
    end
  end
end
