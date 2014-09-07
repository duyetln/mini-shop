require 'controllers/spec_setup'

describe Inventory::DigitalItemsController do
  let(:resource_class) { BackendClient::DigitalItem }
  let(:resource) { digital_item }

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

  describe '#create' do
    let(:title) { rand_str }
    let(:description) { rand_str }
    let(:method) { :post }
    let(:action) { :create }
    let :params do
      {
        digital_item: {
          title: title,
          description: description
        }
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
    end

    include_examples 'redirect response'
    include_examples 'success flash set'
  end

  describe '#update' do
    let(:title) { rand_str }
    let(:description) { rand_str }
    let(:method) { :put }
    let(:action) { :update }
    let :params do
      {
        id: id,
        digital_item: {
          title: title,
          description: description
        }
      }
    end
    let(:update_keys) { [ :title, :description ] }

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
end
