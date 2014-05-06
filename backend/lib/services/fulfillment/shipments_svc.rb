require 'services/base'
require 'models/serializers/fulfillment'

module Services
  module Fulfillment
    class Shipments < Services::Base
      get '/users/:id/shipments' do
        process_request do
          user = User.find(params[:id])
          respond_with(user.shipments.map do |shipment|
            ShipmentSerializer.new(shipment)
          end)
        end
      end
    end
  end
end
