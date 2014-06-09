require 'services/base'
require 'services/serializers/shopping'

module Services
  module Shopping
    class Addresses < Services::Base
      get '/users/:id/addresses' do
        process_request do
          addresses = User.find(params[:id]).addresses
          respond_with(addresses.map do |address|
            AddressSerializer.new(address)
          end)
        end
      end

      post '/users/:id/addresses' do
        process_request do
          address = User.find(params[:id]).addresses.create!(params[:address])
          respond_with(AddressSerializer.new(address))
        end
      end

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
