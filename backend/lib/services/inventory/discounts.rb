require 'services/base'
require 'models/serializers/inventory'

module Services
  module Inventory
    class Discounts < Services::Base
      get '/discounts' do
        process_request do
          discounts = Discount.all
          respond_with(discounts.map do |discount|
            DiscountSerializer.new(discount)
          end)
        end
      end

      post '/discounts' do
        process_request do
          discount = Discount.new(params[:discount])
          discount.save!
          respond_with(DiscountSerializer.new(discount))
        end
      end

      put '/discounts/:id' do
        process_request do
          discount = Discount.find(params[:id])
          discount.update_attributes!(params[:discount])
          respond_with(DiscountSerializer.new(discount))
        end
      end
    end
  end
end