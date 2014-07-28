require 'lib/base'

module BackendClient
  class Price < Base
    include DefaultAll
    include DefaultFind
    include DefaultCreate
    include DefaultUpdate

    def self.instantiate(hash = {})
      super do |price|
        price.pricepoint = Pricepoint.instantiate(price.pricepoint)
        price.discount = Discount.instantiate(price.discount)
      end
    end
  end
end
