module BackendClient
  class Price
    include APIResource
    include APIModel
    include DefaultAll
    include DefaultFind
    include DefaultCreate
    include DefaultUpdate

    def self.build_attributes(hash = {})
      super do |price|
        price.pricepoint = Pricepoint.instantiate(price.pricepoint)
        price.discount = Discount.instantiate(price.discount)
      end
    end
  end
end
