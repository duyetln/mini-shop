require 'controllers/spec_setup'

describe Inventory::PricepointsController do
  let(:resource_class) { BackendClient::Pricepoint }
  let(:resource) { pricepoint }

  render_views

  describe '#index' do
    let(:method) { :get }
    let(:action) { :index }

    before :each do
      expect_all
      expect_all(BackendClient::Currency, currency)
    end

    include_examples 'success response'
    include_examples 'non empty response'
  end

  describe '#create' do
    let(:name) { rand_str }
    let(:currency_id) { rand_str }
    let(:method) { :post }
    let(:action) { :create }
    let :params do
      {
        pricepoint: {
          name: name
        },
        pricepoint_prices: [
          {
            amount: amount,
            currency_id: currency_id
          }
        ]
      }
    end
    let :create_params do
      {
        name: name
      }
    end

    before :each do
      expect_create
      expect(resource).to receive(:create_pricepoint_price).with(
        amount: amount.to_s,
        currency_id: currency_id
      ).at_least(:once)
    end

    include_examples 'redirect response'
    include_examples 'success flash set'
  end

  describe '#update' do
    let(:name) { rand_str }
    let(:currency_id) { rand_str }
    let(:method) { :put }
    let(:action) { :update }
    let :params do
      {
        id: id,
        pricepoint: {
          name: name
        },
        pricepoint_prices: [
          {
            amount: amount,
            currency_id: currency_id
          }
        ]
      }
    end
    let(:update_keys) { [ :name ] }

    before :each do
      expect_find
      expect_update
      expect(resource).to receive(:create_pricepoint_price).with(
        amount: amount.to_s,
        currency_id: currency_id
      ).at_least(:once)
    end

    include_examples 'resource changed'
    include_examples 'redirect response'
    include_examples 'success flash set'
  end
end
