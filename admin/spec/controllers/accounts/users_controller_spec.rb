require 'controllers/spec_setup'

describe Accounts::UsersController do
  let(:resource_class) { BackendClient::User }
  let(:resource) { user }

  render_views

  describe '#index' do
    let(:method) { :get }
    let(:action) { :index }

    before :each do
      expect_all
    end

    include_examples 'success response'
    include_examples 'non empty response'
  end

  describe '#show' do
    let(:method) { :get }
    let(:action) { :show }
    let(:params) { { id: id } }

    before :each do
      expect_find
      expect(resource).to receive(:purchases).at_least(:once).and_return([purchase])
      expect(resource).to receive(:coupons).at_least(:once).and_return([coupon])
      expect(resource).to receive(:ownerships).at_least(:once).and_return([ownership])
      expect(resource).to receive(:shipments).at_least(:once).and_return([shipment])
      expect(coupon).to receive(:promotion).at_least(:once).and_return(promotion)
    end

    include_examples 'success response'
    include_examples 'non empty response'
  end
end
