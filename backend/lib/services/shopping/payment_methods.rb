require 'services/base'

module Services
  module Shopping
    class PaymentMethods < Services::Base
      put '/:id' do
        process_request do
          payment_method = PaymentMethod.find(id)
          payment_method.update_attributes!(params[:payment_method])
          respond_with(PaymentMethodSerializer.new(payment_method))
        end
      end
    end
  end
end
