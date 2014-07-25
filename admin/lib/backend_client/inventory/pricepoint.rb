require 'lib/backend_client/base'

module BackendClient
  class Pricepoint < Base
    extend DefaultAll
    extend DefaultFind
    extend DefaultCreate
    include DefaultUpdate

    def self.instantiate(hash = {})
      super do |pricepoint|
        pricepoint.pricepoint_prices.map! do |pricepoint_price|
          PricepointPrice.instantiate(pricepoint_price)
        end
      end
    end

    def create_pricepoint_price(pricepoint_price = {})
      if pricepoint_price.present?
        self.class.parse(
          self.class.resource["/#{id}/pricepoint_prices"].post PricepointPrice.params(pricepoint_price)
        ) do |hash|
          load!(hash)
          pricepoint_prices.last
        end
      end
    end
  end
end
