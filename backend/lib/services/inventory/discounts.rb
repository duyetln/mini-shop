require 'services/base'

module Services
  module Inventory
    class Discounts < Services::Base
      get '/' do
        discounts = paginate(Discount).all
        respond_with(discounts.map do |discount|
          DiscountSerializer.new(discount)
        end)
      end

      post '/' do
        discount = Discount.new(params[:discount])
        discount.save!
        respond_with(DiscountSerializer.new(discount))
      end

      put '/:id' do
        discount = Discount.find(id)
        discount.update_attributes!(params[:discount])
        respond_with(DiscountSerializer.new(discount))
      end
    end
  end
end
