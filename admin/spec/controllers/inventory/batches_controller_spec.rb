require 'controllers/spec_setup'

describe Inventory::BatchesController do
  let(:resource_class) { BackendClient::Batch }
  let(:resource) { batch }

  render_views

  describe '#show' do
    let(:method) { :get }
    let(:action) { :show }
    let(:params) { { id: id } }

    before :each do
      expect_find
      expect(resource).to receive(:coupons).and_return([coupon])
    end

    include_examples 'success response'
    include_examples 'non empty response'
  end

  describe '#update' do
    let(:method) { :put }
    let(:action) { :update }
    let(:params) { { id: id, batch: { name: rand_str } } }
    let(:update_keys) { [ :name ] }

    before :each do
      expect_find
      expect_update
    end

    include_examples 'resource changed'
    include_examples 'redirect response'
    include_examples 'success flash set'
  end

  include_examples '#activate'
  include_examples '#destroy'

  describe '#coupons' do
    let(:method) { :post }
    let(:action) { :coupons }
    let(:params) { { id: id, qty: qty } }

    before :each do
      expect_find
      expect(resource).to receive(:create_coupons).with(qty.to_s)
    end

    include_examples 'redirect response'
    include_examples 'success flash set'
  end
end
