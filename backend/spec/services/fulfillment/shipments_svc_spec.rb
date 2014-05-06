require 'services/spec_setup'
require 'spec/services/shared/errors'

describe Services::Fulfillment::Shipments do
  let :user do
    User.find FactoryGirl.create(:user).id
  end
  let(:id) { user.id }

  describe 'get /users/:id/shipments' do
    let(:method) { :get }
    let(:path) { "/users/#{id}/shipments" }

    context 'invalid id' do
      let(:id) { rand_str }

      include_examples 'not found'
    end

    context 'valid id' do
      it 'returns the shipments' do
        send_request
        expect_status(200)
        expect_response(user.shipments.map do |shipment|
          ShipmentSerializer.new(shipment)
        end.to_json)
      end
    end
  end
end
