require 'services/base'
require 'models/serializers/shopping'

module Services
  module Shopping
    class PaymentMethods < Services::Base
      get '/users/:id/payment_methods' do
        process_request do
          payment_methods = User.find(params[:id]).payment_methods
          respond_with(payment_methods.map do |payment_method|
            PaymentMethodSerializer.new(payment_method)
          end)
        end
      end

      post '/users/:id/payment_methods' do
        process_request do
          payment_method = User.find(params[:id]).payment_methods.create!(params[:payment_method])
          respond_with(PaymentMethodSerializer.new(payment_method))
        end
      end

      put '/users/:id/payment_methods/:payment_method_id' do
        process_request do
          payment_method = User.find(params[:id]).payment_methods.find(params[:payment_method_id])
          payment_method.update_attributes!(params[:payment_method])
          respond_with(PaymentMethodSerializer.new(payment_method))
        end
      end
    end
  end
end
