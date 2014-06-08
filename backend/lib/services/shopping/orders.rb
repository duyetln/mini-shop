require 'services/base'
require 'services/serializers/shopping'

module Services
  module Shopping
    class Orders < Services::Base
      get '/users/:id/orders' do
        process_request do
          orders = User.find(params[:id]).purchases.map(&:orders).flatten
          respond_with(orders.map do |order|
            OrderSerializer.new(order)
          end)
        end
      end
    end
  end
end
