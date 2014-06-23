require 'services/base'
require 'models/serializers/shopping'

module Services
  module Shopping
    class PaymentMethods < Services::Base
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
