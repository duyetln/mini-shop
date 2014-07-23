require 'services/base'

module Services
  module Shopping
    class Addresses < Services::Base
      put '/:id' do
        address = Address.find(id)
        address.update_attributes!(params[:address])
        respond_with(AddressSerializer.new(address))
      end
    end
  end
end
