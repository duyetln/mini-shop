require 'services/base'
require 'services/serializers/shopping'

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

      put '/payment_methods/:id' do
        process_request do
          payment_method = PaymentMethod.find(params[:id])
          payment_method.update_attributes!(params[:payment_method])
          respond_with(PaymentMethodSerializer.new(payment_method))
        end
      end
    end
  end
end
