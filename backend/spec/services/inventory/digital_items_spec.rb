require 'services/spec_setup'
require 'spec/services/shared/errors'

describe Services::Inventory::DigitalItems do
  describe 'get /digital_items' do
    let(:method) { :get }
    let(:path) { '/digital_items' }

    before :each do
      FactoryGirl.create :digital_item
    end

    it 'returns all digital items' do
      send_request
      expect_status(200)
      expect_response(DigitalItem.all.map do |item|
        DigitalItemSerializer.new(item)
      end.to_json)
    end
  end

  describe 'post /digital_items' do
    let(:method) { :post }
    let(:path) { '/digital_items' }

    context 'invalid parameters' do
      let(:params) { {} }

      include_examples 'bad request'

      it 'does not create new digital item' do
        expect { send_request }.to_not change { DigitalItem.count }
      end
    end

    context 'valid parameters' do
      let(:params) { { digital_item: FactoryGirl.build(:digital_item).attributes } }

      it 'creates new digital item' do
        expect { send_request }.to change { DigitalItem.count }.by(1)
        expect_status(200)
        expect_response(DigitalItemSerializer.new(DigitalItem.last).to_json)
      end
    end
  end

  describe 'put /digital_items/:id' do
    let(:method) { :put }
    let(:path) { "/digital_items/#{id}" }

    include_examples 'invalid id'

    context 'valid id' do
      let(:digital_item) { FactoryGirl.create :digital_item }
      let(:id) { digital_item.id }

      context 'invalid parameters' do
        let(:params) { { digital_item: { title: nil } } }

        include_examples 'bad request'

        it 'does not update the digital item' do
          expect { send_request }.to_not change { digital_item.reload.attributes }
        end
      end

      context 'valid parameters' do
        let(:params) { { digital_item: { title: rand_str } } }

        it 'updates the the digital item' do
          expect { send_request }.to change { digital_item.reload.attributes }
          expect_status(200)
          expect_response(DigitalItemSerializer.new(digital_item).to_json)
        end
      end
    end
  end

  describe 'put /digital_items/:id/activate' do
    let(:method) { :put }
    let(:path) { "/digital_items/#{id}/activate" }

    include_examples 'invalid id'

    context 'valid id' do
      let(:digital_item) { FactoryGirl.create :digital_item }
      let(:id) { digital_item.id }

      context 'activated digital item' do
        before :each do
          digital_item.activate!
        end

        include_examples 'not found'

        it 'does not update the digital item' do
          expect { send_request }.to_not change { digital_item.reload.attributes }
        end
      end

      context 'unactivated digital item' do
        before :each do
          expect(digital_item).to be_inactive
        end

        it 'activates the digital item' do
          expect { send_request }.to change { digital_item.reload.active? }.to(true)
          expect_status(200)
          expect_response(DigitalItemSerializer.new(digital_item).to_json)
        end
      end
    end
  end

  describe 'delete /digital_items/:id' do
    let(:method) { :delete }
    let(:path) { "/digital_items/#{id}" }

    include_examples 'invalid id'

    context 'valid id' do
      let(:digital_item) { FactoryGirl.create :digital_item }
      let(:id) { digital_item.id }

      context 'activated digital item' do
        before :each do
          digital_item.activate!
        end

        include_examples 'not found'

        it 'does not update the digital item' do
          expect { send_request }.to_not change { digital_item.reload.attributes }
        end
      end

      context 'deleted digital item' do
        before :each do
          digital_item.delete!
        end

        include_examples 'not found'

        it 'does not update the digital item' do
          expect { send_request }.to_not change { digital_item.reload.attributes }
        end
      end

      context 'undeleted, inactive digital item' do
        before :each do
          expect(digital_item).to be_kept
          expect(digital_item).to be_inactive
        end

        it 'deletes the digital item' do
          expect { send_request }.to change { DigitalItem.count }.by(-1)
          expect_status(200)
          expect_response(DigitalItemSerializer.new(digital_item.reload).to_json)
        end
      end
    end
  end
end
