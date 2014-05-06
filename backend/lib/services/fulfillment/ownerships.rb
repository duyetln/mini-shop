require 'services/base'
require 'models/serializers/fulfillment'

module Services
  module Fulfillment
    class Ownerships < Services::Base
      get '/users/:id/ownerships' do
        process_request do
          user = User.find(params[:id])
          respond_with(user.ownerships.map do |ownership|
            OwnershipSerializer.new(ownership)
          end)
        end
      end
    end
  end
end
