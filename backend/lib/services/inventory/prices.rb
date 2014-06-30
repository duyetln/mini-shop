require 'services/base'

module Services
  module Inventory
    class Prices < Services::Base
      get '/' do
        process_request do
          prices = Price.all
          respond_with(prices.map do |price|
            PriceSerializer.new(price)
          end)
        end
      end

      get '/:id' do
        process_request do
          price = Price.find(params[:id])
          respond_with(PriceSerializer.new(price))
        end
      end

      post '/' do
        process_request do
          price = Price.new(params[:price])
          price.save!
          respond_with(PriceSerializer.new(price))
        end
      end

      put '/:id' do
        process_request do
          price = Price.find(params[:id])
          price.update_attributes!(params[:price])
          respond_with(PriceSerializer.new(price))
        end
      end
    end
  end
end
