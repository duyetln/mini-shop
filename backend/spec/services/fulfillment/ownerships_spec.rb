require 'services/spec_setup'
require 'spec/services/shared/errors'

describe Services::Fulfillment::Ownerships do
  let(:user) { FactoryGirl.create(:user).reload }
  let(:id) { user.id }

  describe 'get /users/:id/ownerships' do
    let(:method) { :get }
    let(:path) { "/users/#{id}/ownerships" }

    include_examples 'invalid id'

    context 'valid id' do
      before :each do
        FactoryGirl.create :ownership, user: user
      end

      it 'returns the ownerships' do
        send_request
        expect_status(200)
        expect_response(user.ownerships.map do |ownership|
          OwnershipSerializer.new(ownership)
        end.to_json)
      end
    end
  end
end
