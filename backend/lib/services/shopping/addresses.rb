require 'services/base'

module Services
  module Shopping
    class Addresses < Services::Base
      put '/:id' do
        process_request do
          address = Address.find(params[:id])
          address.update_attributes!(params[:address])
          respond_with(AddressSerializer.new(address))
        end
      end
    end
  end
end
