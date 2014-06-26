class StoreItem < ServiceResource
  extend DefaultAll
  extend DefaultCreate
  include DefaultUpdate

  def self.instantiate(hash = {})
    super do |store_item|
      store_item.item = ServiceResource.concretize(store_item.item)
      store_item.price = Price.instantiate(store_item.price)
    end
  end
end
