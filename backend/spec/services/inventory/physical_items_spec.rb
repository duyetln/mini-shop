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

      it 'does not create new physical item' do
        expect { send_request }.to_not change { PhysicalItem.count }
      end
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

        it 'does not update the physical item' do
          expect { send_request }.to_not change { physical_item.reload.attributes }
        end
      end

      context 'valid parameters' do
        let(:params) { { physical_item: { title: rand_str } } }

        it 'updates the the physical item' do
          expect { send_request }.to change { physical_item.reload.attributes }
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
          physical_item.activate!
        end

        include_examples 'not found'

        it 'does not update the physical item' do
          expect { send_request }.to_not change { physical_item.reload.attributes }
        end
      end

      context 'unactivated physical item' do
        before :each do
          expect(physical_item).to be_inactive
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

      context 'activated physical item' do
        before :each do
          physical_item.activate!
        end

        include_examples 'not found'

        it 'does not update the physical item' do
          expect { send_request }.to_not change { physical_item.reload.attributes }
        end
      end

      context 'deleted physical item' do
        before :each do
          physical_item.delete!
        end

        include_examples 'not found'

        it 'does not update the physical item' do
          expect { send_request }.to_not change { physical_item.reload.attributes }
        end
      end

      context 'undeleted, inactive physical item' do
        before :each do
          expect(physical_item).to be_kept
          expect(physical_item).to be_inactive
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
