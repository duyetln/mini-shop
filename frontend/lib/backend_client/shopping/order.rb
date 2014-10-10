module BackendClient
  class Order
    include APIModel
    STATUS = { failed: -2, invalid: -1, fulfilled: 1, reversed: 2 }

    def self.build_attributes(hash = {})
      super do |order|
        order.item = APIModel.instantiate(order.item)
        order.amount = BigDecimal.new(order.amount)
        order.currency = Currency.instantiate(order.currency)
        order.tax = BigDecimal.new(order.tax)
        order.tax_rate = BigDecimal.new(order.tax_rate)
        order.total = BigDecimal.new(order.total)
        order.refund_transaction = RefundTransaction.instantiate(order.refund_transaction)
        order.statuses.map! { |status| Status.instantiate(status) }
      end
    end

    def status
      statuses.find { |status| status.id == status_id }
    end
  end
end
