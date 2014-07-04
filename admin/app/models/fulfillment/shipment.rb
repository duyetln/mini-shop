class Shipment < ServiceResource
  def self.instantiate(hash = {})
    super do |shipment|
      shipment.item = ServiceResource.concretize(shipment.item)
      shipment.shipping_address = Address.instantiate(shipment.shipping_address)
    end
  end
end
