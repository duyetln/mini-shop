module BackendClient
  class Purchase
    include APIResource
    include APIModel
    include DefaultFind
    include DefaultUpdate

    def self.build_attributes(hash = {})
      super do |purchase|
        purchase.payment_method = PaymentMethod.instantiate(purchase.payment_method)
        purchase.billing_address = Address.instantiate(purchase.billing_address)
        purchase.shipping_address = Address.instantiate(purchase.shipping_address)
        purchase.payment = Transaction.instantiate(purchase.payment)
        purchase.orders.map! { |order| Order.instantiate(order) }
      end
    end

    def add_or_update_order(order = {})
      if order.present?
        load!(
          self.class.post(
            path: "/#{id}/orders",
            payload: Order.params(order)
          )
        )
        orders.last
      end
    end

    def delete_order(order_id)
      load!(
        self.class.delete(
          path: "/#{id}/orders/#{order_id}"
        )
      )
      orders.count
    end

    def submit!
      load!(
        self.class.put(
          path: "/#{id}/submit"
        )
      )
    end

    def return!
      load!(
        self.class.put(
          path: "/#{id}/return"
        )
      )
    end

    def return_order(order_id)
      load!(
        self.class.put(
          path: "/#{id}/orders/#{order_id}/return"
        )
      )
      orders.find { |order| order.id == order_id }
    end
  end
end