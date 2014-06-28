class Shipment < ServiceResource
  def self.instantiate(hash = {})
    super do |shipment|
      shipment.item = ServiceResource.concretize(ownership.item)
      shipment.shipping_address = Shipment.instantiate(shipment.shipping_address)
    end
  end
end
