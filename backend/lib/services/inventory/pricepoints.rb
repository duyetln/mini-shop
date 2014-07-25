require 'services/base'

module Services
  module Inventory
    class Pricepoints < Services::Base
      get '/' do
        pricepoints = paginate(Pricepoint).all
        respond_with(pricepoints.map do |pricepoint|
          PricepointSerializer.new(pricepoint)
        end)
      end

      get '/:id' do
        pricepoint = Pricepoint.find(id)
        respond_with(PricepointSerializer.new(pricepoint))
      end

      post '/' do
        pricepoint = Pricepoint.new(params[:pricepoint])
        pricepoint.save!
        respond_with(PricepointSerializer.new(pricepoint))
      end

      put '/:id' do
        pricepoint = Pricepoint.find(id)
        pricepoint.update_attributes!(params[:pricepoint])
        respond_with(PricepointSerializer.new(pricepoint))
      end

      post '/:id/pricepoint_prices' do
        pricepoint = Pricepoint.find(id)
        pricepoint
          .pricepoint_prices
          .create!(params[:pricepoint_price])
        respond_with(PricepointSerializer.new(pricepoint))
      end
    end
  end
end
