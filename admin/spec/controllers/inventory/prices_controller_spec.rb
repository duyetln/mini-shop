require 'controllers/spec_setup'

describe Inventory::PricesController do
  let(:resource_class) { BackendClient::Price }
  let(:resource) { price }

  render_views

  describe '#index' do
    let(:method) { :get }
    let(:action) { :index }

    before :each do
      expect_all
      expect_all(BackendClient::Pricepoint, pricepoint)
      expect_all(BackendClient::Discount, discount)
    end

    include_examples 'success response'
    include_examples 'non empty response'
  end

  describe '#create' do
    let(:name) { rand_str }
    let(:pricepoint_id) { rand_str }
    let(:discount_id) { rand_str }
    let(:method) { :post }
    let(:action) { :create }
    let :params do
      {
        price: {
          name: name,
          pricepoint_id: pricepoint_id,
          discount_id: discount_id
        }
      }
    end
    let :create_params do
      {
        name: name,
        pricepoint_id: pricepoint_id,
        discount_id: discount_id
      }
    end

    before :each do
      expect_create
    end

    include_examples 'redirect response'
    include_examples 'success flash set'
  end

  describe '#update' do
    let(:name) { rand_str }
    let(:pricepoint_id) { rand_str }
    let(:discount_id) { rand_str }
    let(:method) { :put }
    let(:action) { :update }
    let :params do
      {
        id: id,
        price: {
          name: name,
          pricepoint_id: pricepoint_id,
          discount_id: discount_id
        }
      }
    end
    let(:update_keys) { [ :name, :pricepoint_id, :discount_id ] }

    before :each do
      expect_find
      expect_update
    end

    include_examples 'resource changed'
    include_examples 'redirect response'
    include_examples 'success flash set'
  end
end
