require 'services/spec_setup'
require 'spec/services/shared/errors'

describe Services::Inventory::PhysicalItems do
  describe 'get /physical_items' do
    let(:method) { :get }
    let(:path) { '/physical_items' }

    before :each do
      FactoryGirl.create :physical_item
    end

    it 'returns all physical items' do
      send_request
      expect_status(200)
      expect_response(PhysicalItem.all.map do |item|
        PhysicalItemSerializer.new(item)
      end.to_json)
    end
  end

  describe 'post /physical_items' do
    let(:method) { :post }
    let(:path) { '/physical_items' }

    context 'invalid parameters' do
      let(:params) { {} }

      include_examples 'bad request'
    end

    context 'valid parameters' do
      let(:params) { { physical_item: FactoryGirl.build(:physical_item).attributes } }

      it 'creates new physical item' do
        expect { send_request }.to change { PhysicalItem.count }.by(1)
        expect_status(200)
        expect_response(PhysicalItemSerializer.new(PhysicalItem.last).to_json)
      end
    end
  end

  describe 'put /physical_items/:id' do
    let(:method) { :put }
    let(:path) { "/physical_items/#{id}" }

    include_examples 'invalid id'

    context 'valid id' do
      let(:physical_item) { FactoryGirl.create :physical_item }
      let(:id) { physical_item.id }

      context 'invalid parameters' do
        let(:params) { { physical_item: { title: nil } } }

        include_examples 'bad request'
      end

      context 'valid parameters' do
        let(:params) { { physical_item: physical_item.attributes } }

        it 'updates the existing physical item' do
          send_request
          expect_status(200)
          expect_response(PhysicalItemSerializer.new(physical_item).to_json)
        end
      end
    end
  end

  describe 'put /physical_items/:id/activate' do
    let(:method) { :put }
    let(:path) { "/physical_items/#{id}/activate" }

    include_examples 'invalid id'

    context 'valid id' do
      let(:physical_item) { FactoryGirl.create :physical_item }
      let(:id) { physical_item.id }

      context 'activated physical item' do
        before :each do
          expect(physical_item).to be_active
        end

        include_examples 'not found'
      end

      context 'unactivated physical item' do
        before :each do
          physical_item.deactivate!
        end

        it 'activates the physical item' do
          expect { send_request }.to change { physical_item.reload.active? }.to(true)
          expect_status(200)
          expect_response(PhysicalItemSerializer.new(physical_item).to_json)
        end
      end
    end
  end

  describe 'delete /physical_items/:id' do
    let(:method) { :delete }
    let(:path) { "/physical_items/#{id}" }

    include_examples 'invalid id'

    context 'valid id' do
      let(:physical_item) { FactoryGirl.create :physical_item }
      let(:id) { physical_item.id }

      context 'deleted physical item' do
        before :each do
          physical_item.delete!
        end

        include_examples 'not found'
      end

      context 'undeleted physical item' do
        before :each do
          expect(physical_item).to be_kept
        end

        it 'deletes the physical item' do
          expect { send_request }.to change { PhysicalItem.count }.by(-1)
          expect_status(200)
          expect_response(PhysicalItemSerializer.new(physical_item.reload).to_json)
        end
      end
    end
  end
end
