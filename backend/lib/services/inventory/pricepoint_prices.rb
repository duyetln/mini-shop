require 'services/base'

module Services
  module Inventory
    class PricepointPrices < Services::Base
      put '/:id' do
        process_request do
          pricepoint_price = PricepointPrice.find(params[:id])
          pricepoint_price.update_attributes!(params[:pricepoint_price])
          respond_with(PricepointPriceSerializer.new(pricepoint_price))
        end
      end
    end
  end
end
