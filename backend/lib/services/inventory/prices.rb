require 'services/base'

module Services
  module Inventory
    class Prices < Services::Base
      get '/' do
        prices = paginate(Price).all
        respond_with(prices.map do |price|
          PriceSerializer.new(price)
        end)
      end

      get '/:id' do
        price = Price.find(id)
        respond_with(PriceSerializer.new(price))
      end

      post '/' do
        price = Price.new(params[:price])
        price.save!
        respond_with(PriceSerializer.new(price))
      end

      put '/:id' do
        price = Price.find(id)
        price.update_attributes!(params[:price])
        respond_with(PriceSerializer.new(price))
      end
    end
  end
end
