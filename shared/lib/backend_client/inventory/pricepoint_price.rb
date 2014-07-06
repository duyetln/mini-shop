require 'backend_client/base'

module BackendClient
  class PricepointPrice < Base
    include DefaultUpdate

    def self.instantiate(hash = {})
      super do |pricepoint_price|
        pricepoint_price.currency = Currency.instantiate(pricepoint_price.currency)
        pricepoint_price.amount = BigDecimal.new(pricepoint_price.amount)
      end
    end
  end
end
