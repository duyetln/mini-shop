require 'controllers/spec_setup'

describe Inventory::PromotionsController do
  let(:resource_class) { BackendClient::Promotion }
  let(:resource) { promotion }

  render_views

  describe '#index' do
    let(:method) { :get }
    let(:action) { :index }

    before :each do
      expect_all
      expect_all(BackendClient::PhysicalItem, physical_item)
      expect_all(BackendClient::DigitalItem, digital_item)
      expect_all(BackendClient::Bundle, bundle)
      expect_all(BackendClient::Price, price)
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
      expect_all(BackendClient::Price, price)
      expect(resource).to receive(:batches).and_return([batch])
    end

    include_examples 'success response'
    include_examples 'non empty response'
  end

  describe '#create' do
    let(:name) { rand_str }
    let(:title) { rand_str }
    let(:description) { rand_str }
    let(:price_id) { rand_str }
    let(:item_type) { rand_str }
    let(:item_id) { rand_str }
    let(:method) { :post }
    let(:action) { :create }
    let :params do
      {
        id: id,
        promotion: {
          name: name,
          title: title,
          description: description,
          price_id: price_id,
          item: {
            item_type: item_type,
            item_id: item_id
          }.to_json
        }
      }
    end
    let :create_params do
      {
        name: name,
        title: title,
        description: description,
        price_id: price_id,
        item_type: item_type,
        item_id: item_id
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
    let(:title) { rand_str }
    let(:description) { rand_str }
    let(:price_id) { rand_str }
    let(:method) { :put }
    let(:action) { :update }
    let :params do
      { id: id,
        promotion: {
          name: name,
          title: title,
          description: description,
          price_id: price_id
        }
      }
    end
    let(:update_keys) { [ :name, :title, :description, :price_id ] }

    before :each do
      expect_find
      expect_update
    end

    include_examples 'redirect response'
    include_examples 'success flash set'
  end

  include_examples '#activate'
  include_examples '#destroy'

  describe '#batches' do
    let(:size) { rand_num }
    let(:method) { :post }
    let(:action) { :batches }
    let(:params) { { id: id, qty: qty, batch: { size: size } } }

    before :each do
      expect_find
      expect(resource).to receive(:create_batches).with(qty.to_s, size.to_s)
    end

    include_examples 'redirect response'
    include_examples 'success flash set'
  end
end
