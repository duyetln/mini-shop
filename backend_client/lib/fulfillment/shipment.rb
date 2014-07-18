require 'lib/base'

module BackendClient
  class Shipment < Base
    def self.instantiate(hash = {})
      super do |shipment|
        shipment.item = Base.concretize(shipment.item)
        shipment.shipping_address = Address.instantiate(shipment.shipping_address)
      end
    end
  end
end
