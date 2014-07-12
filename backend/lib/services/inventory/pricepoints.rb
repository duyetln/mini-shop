require 'services/base'

module Services
  module Inventory
    class Pricepoints < Services::Base
      get '/' do
        process_request do
          pricepoints = Pricepoint.all
          respond_with(pricepoints.map do |pricepoint|
            PricepointSerializer.new(pricepoint)
          end)
        end
      end

      post '/' do
        process_request do
          pricepoint = Pricepoint.new(params[:pricepoint])
          pricepoint.save!
          respond_with(PricepointSerializer.new(pricepoint))
        end
      end

      put '/:id' do
        process_request do
          pricepoint = Pricepoint.find(id)
          pricepoint.update_attributes!(params[:pricepoint])
          respond_with(PricepointSerializer.new(pricepoint))
        end
      end

      post '/:id/pricepoint_prices' do
        process_request do
          pricepoint = Pricepoint.find(id)
          pricepoint
            .pricepoint_prices
            .create!(params[:pricepoint_price])
          respond_with(PricepointSerializer.new(pricepoint))
        end
      end
    end
  end
end
