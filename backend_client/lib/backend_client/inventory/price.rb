module BackendClient
  class Price < APIModel
    include DefaultAll
    include DefaultFind
    include DefaultCreate
    include DefaultUpdate

    def self.build_attributes(hash = {})
      super do |price|
        price.pricepoint = Pricepoint.new(price.pricepoint)
        price.discount = Discount.new(price.discount)
      end
    end
  end
end
