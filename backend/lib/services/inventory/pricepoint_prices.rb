require 'services/base'

module Services
  module Inventory
    class PricepointPrices < Services::Base
      put '/:id' do
        pricepoint_price = PricepointPrice.find(id)
        pricepoint_price.update_attributes!(params[:pricepoint_price])
        respond_with(PricepointPriceSerializer.new(pricepoint_price))
      end
    end
  end
end
