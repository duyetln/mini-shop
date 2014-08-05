module BackendClient
  class Transaction
    include APIModel

    def self.build_attributes(hash = {})
      super do |transaction|
        transaction.amount = BigDecimal.new(transaction.amount)
        transaction.currency = Currency.instantiate(transaction.currency)
        transaction.committed_at = DateTime.parse(transaction.committed_at) if transaction.committed_at.present?
      end
    end
  end
end
