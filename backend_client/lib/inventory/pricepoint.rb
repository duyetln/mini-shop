require 'lib/base'

module BackendClient
  class Pricepoint < Base
    include DefaultAll
    include DefaultFind
    include DefaultCreate
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
        catch_error RestClient::BadRequest do
          fail BackendClient::Errors::BadRequest.new(
            "Unable to create #{PricepointPrice.humanized_name}",
            (Yajl::Parser.parse(@error.http_body)['message'] rescue nil)
          )
        end
        handle_error do
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
end
