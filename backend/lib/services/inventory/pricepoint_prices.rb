require 'services/base'
require 'models/serializers/inventory'

module Services
  module Inventory
    class PricepointPrices < Services::Base
      put '/pricepoint_prices/:id' do
        process_request do
          pricepoint_price = PricepointPrice.find(params[:id])
          pricepoint_price.update_attributes!(params[:pricepoint_price])
          respond_with(PricepointPriceSerializer.new(pricepoint_price))
        end
      end
    end
  end
end
