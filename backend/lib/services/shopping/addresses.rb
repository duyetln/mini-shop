require 'services/base'
require 'models/serializers/shopping'

module Services
  module Shopping
    class Addresses < Services::Base
      put '/addresses/:id' do
        process_request do
          address = Address.find(params[:id])
          address.update_attributes!(params[:address])
          respond_with(AddressSerializer.new(address))
        end
      end
    end
  end
end
