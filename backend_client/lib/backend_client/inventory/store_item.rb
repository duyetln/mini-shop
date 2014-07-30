module BackendClient
  class StoreItem < APIModel
    include DefaultAll
    include DefaultFind
    include DefaultCreate
    include DefaultUpdate
    include DefaultDelete

    def self.build_attributes(hash = {})
      super do |store_item|
        store_item.item = APIModel.instantiate(store_item.item)
        store_item.price = Price.new(store_item.price)
      end
    end
  end
end
