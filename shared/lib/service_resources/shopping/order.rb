class Order < ServiceResource
  def self.instantiate(hash = {})
    super do |order|
      order.item = ServiceResource.concretize(order.item)
      order.amount = BigDecimal.new(order.amount)
      order.tax = BigDecimal.new(order.tax)
      order.tax_rate = BigDecimal.new(order.tax_rate)
      order.total = BigDecimal.new(order.total)
      order.refund = Transaction.instantiate(order.refund)
      order.statuses.map! { |status| Status.instantiate(status) }
    end
  end
end
