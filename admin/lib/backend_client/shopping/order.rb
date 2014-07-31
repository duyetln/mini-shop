module BackendClient
  class Order
    include APIModel

    def self.build_attributes(hash = {})
      super do |order|
        order.item = APIModel.instantiate(order.item)
        order.amount = BigDecimal.new(order.amount)
        order.tax = BigDecimal.new(order.tax)
        order.tax_rate = BigDecimal.new(order.tax_rate)
        order.total = BigDecimal.new(order.total)
        order.refund = Transaction.new(order.refund)
        order.statuses.map! { |status| Status.new(status) }
      end
    end
  end
end
