module BackendClient
  class Ownership
    include APIModel

    def self.build_attributes(hash = {})
      super do |ownership|
        ownership.item = APIModel.instantiate(ownership.item)
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
