require 'services/base'
require 'models/serializers/inventory'

module Services
  module Inventory
    class Pricepoints < Services::Base
      get '/pricepoints' do
        process_request do
          pricepoints = Pricepoint.all
          respond_with(pricepoints.map do |pricepoint|
            PricepointSerializer.new(pricepoint)
          end)
        end
      end

      post '/pricepoints' do
        process_request do
          pricepoint = Pricepoint.new(params[:pricepoint])
          pricepoint.save!
          respond_with(PricepointSerializer.new(pricepoint))
        end
      end

      put '/pricepoints/:id' do
        process_request do
          pricepoint = Pricepoint.find(params[:id])
          pricepoint.update_attributes!(params[:pricepoint])
          respond_with(PricepointSerializer.new(pricepoint))
        end
      end

      post '/pricepoints/:id/pricepoint_prices' do
        process_request do
          pricepoint = Pricepoint.find(params[:id])
          pricepoint
            .pricepoint_prices
            .create!(params[:pricepoint_price])
          respond_with(PricepointSerializer.new(pricepoint))
        end
      end

      put '/pricepoints/:id/pricepoint_prices/:pricepoint_price_id' do
        process_request do
          pricepoint = Pricepoint.find(params[:id])
          pricepoint
            .pricepoint_prices
            .find(params[:pricepoint_price_id])
            .update_attributes!(params[:pricepoint_price])
          respond_with(PricepointSerializer.new(pricepoint))
        end
      end
    end
  end
end
