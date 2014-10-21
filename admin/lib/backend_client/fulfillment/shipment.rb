module BackendClient
  class Shipment
    include APIModel

    def self.build_attributes(hash = {})
      super do |shipment|
        shipment.item = APIModel.instantiate(shipment.item)
        shipment.shipping_address = Address.instantiate(shipment.shipping_address)
      end
    end

    def purchase
      @cache[:purchase] ||= Purchase.find(purchase_id)
    end

    def order
      purchase.orders.find { |order| order.id == order_id }
    end
  end
end
