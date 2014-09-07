require 'controllers/spec_setup'

describe Inventory::BundlesController do
  let(:resource_class) { BackendClient::Bundle }
  let(:resource) { bundle }

  render_views

  describe '#index' do
    let(:method) { :get }
    let(:action) { :index }

    before :each do
      expect_all
      expect_all(BackendClient::PhysicalItem, physical_item)
      expect_all(BackendClient::DigitalItem, digital_item)
    end

    include_examples 'success response'
    include_examples 'non empty response'
  end

  describe '#create' do
    let(:title) { rand_str }
    let(:description) { rand_str }
    let(:item_type) { rand_str }
    let(:item_id) { rand_str }

    let(:method) { :post }
    let(:action) { :create }
    let :params do
      {
        bundle: {
          title: title,
          description: description
        },
        bundleds: [
          {
            item: {
              item_type: item_type,
              item_id: item_id
            }.to_json,
            qty: qty
          }
        ]
      }
    end
    let :create_params do
      {
        title: title,
        description: description
      }
    end

    before :each do
      expect_create
      expect(resource).to receive(:add_or_update_bundled).with(
        qty: qty.to_s,
        item_type: item_type,
        item_id: item_id
      ).at_least(:once)
    end

    include_examples 'redirect response'
    include_examples 'success flash set'
  end

  describe '#show' do
    let(:method) { :get }
    let(:action) { :show }
    let(:params) { { id: id } }

    before :each do
      expect_find
      expect_all(BackendClient::PhysicalItem, physical_item)
      expect_all(BackendClient::DigitalItem, digital_item)
    end

    include_examples 'success response'
    include_examples 'non empty response'
  end

  describe '#update' do
    let(:title) { rand_str }
    let(:description) { rand_str }
    let(:item_type) { rand_str }
    let(:item_id) { rand_str }

    let(:method) { :put }
    let(:action) { :update }
    let :params do
      {
        id: id,
        bundle: {
          title: title,
          description: description
        },
        bundleds: [
          {
            item: {
              item_type: item_type,
              item_id: item_id
            }.to_json,
            qty: qty
          }
        ]
      }
    end
    let(:update_keys) { [ :title, :description ] }

    before :each do
      expect_find
      expect_update
      expect(resource).to receive(:add_or_update_bundled).with(
        qty: qty.to_s,
        item_type: item_type,
        item_id: item_id
      ).at_least(:once)
    end

    include_examples 'resource changed'
    include_examples 'redirect response'
    include_examples 'success flash set'
  end

  include_examples '#activate'
  include_examples '#destroy'
end
