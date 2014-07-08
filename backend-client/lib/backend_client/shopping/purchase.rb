require 'backend_client/base'

module BackendClient
  class Purchase < Base
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

    def create_order(order = {})
      if order.present?
        self.class.parse(
          self.class.resource["/#{id}/orders"].post Order.params(order)
        ) do |hash|
          load!(hash)
          orders.last
        end
      end
    end

    def delete_order(order_id)
      self.class.parse(
        self.class.resource["/#{id}/orders/#{order_id}"].delete
      ) do |hash|
        load!(hash)
        orders.count
      end
    end

    def submit!
      self.class.parse(
        self.class.resource["/#{id}/submit"].put({})
      ) do |hash|
        load!(hash)
      end
    end

    def return!
      self.class.parse(
        self.class.resource["/#{id}/return"].put({})
      ) do |hash|
        load!(hash)
      end
    end

    def return_order(order_id)
      self.class.parse(
        self.class.resource["/#{id}/orders/#{order_id}/return"].put({})
      ) do |hash|
        load!(hash)
        orders.find { |order| order.id == order_id }
      end
    end
  end
end
