module BackendClient
  class Shipment < APIModel
    def self.build_attributes(hash = {})
      super do |shipment|
        shipment.item = APIModel.instantiate(shipment.item)
        shipment.shipping_address = Address.new(shipment.shipping_address)
      end
    end
  end
end
