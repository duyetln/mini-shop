require 'lib/base'

module BackendClient
  class StoreItem < Base
    include DefaultAll
    include DefaultFind
    include DefaultCreate
    include DefaultUpdate
    include DefaultDelete

    def self.instantiate(hash = {})
      super do |store_item|
        store_item.item = Base.concretize(store_item.item)
        store_item.price = Price.instantiate(store_item.price)
      end
    end
  end
end
