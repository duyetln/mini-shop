require 'services/spec_setup'
require 'spec/services/shared/errors'

describe Services::Shopping::Orders do
  let(:user) { FactoryGirl.create(:user).reload }
  let(:id) { user.id }

  describe 'get /users/:id/orders' do
    let(:method) { :get }
    let(:path) { "/users/#{id}/orders" }

    include_examples 'invalid id'

    context 'valid id' do
      before :each do
        FactoryGirl.create :order, purchase: FactoryGirl.create(:purchase, user: user)
      end

      it 'returns the orders' do
        send_request
        expect_status(200)
        expect_response(user.purchases.map(&:orders).flatten.map do |order|
          OrderSerializer.new(order)
        end.to_json)
      end
    end
  end
end
