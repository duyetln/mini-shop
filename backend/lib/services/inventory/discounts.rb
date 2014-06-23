require 'services/base'

module Services
  module Inventory
    class Discounts < Services::Base
      get '/' do
        process_request do
          discounts = Discount.all
          respond_with(discounts.map do |discount|
            DiscountSerializer.new(discount)
          end)
        end
      end

      post '/' do
        process_request do
          discount = Discount.new(params[:discount])
          discount.save!
          respond_with(DiscountSerializer.new(discount))
        end
      end

      put '/:id' do
        process_request do
          discount = Discount.find(params[:id])
          discount.update_attributes!(params[:discount])
          respond_with(DiscountSerializer.new(discount))
        end
      end
    end
  end
end
