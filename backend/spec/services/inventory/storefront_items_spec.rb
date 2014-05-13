require 'services/spec_setup'
require 'spec/services/shared/errors'

describe Services::Inventory::StorefrontItems do
  describe 'get /storefront_items' do
    let(:method) { :get }
    let(:path) { '/storefront_items' }

    before :each do
      FactoryGirl.create :storefront_item
    end

    it 'returns all storefront items' do
      send_request
      expect_status(200)
      expect_response(StorefrontItem.all.map do |item|
        StorefrontItemSerializer.new(item)
      end.to_json)
    end
  end

  describe 'post /storefront_items' do
    let(:method) { :post }
    let(:path) { '/storefront_items' }

    context 'invalid parameters' do
      let(:params) { {} }

      include_examples 'bad request'

      it 'does not create new storefront item' do
        expect { send_request }.to_not change { StorefrontItem.count }
      end
    end

    context 'valid parameters' do
      let(:price) { FactoryGirl.create :price, :discounted }
      let :item do
        FactoryGirl.create [
          :bundle_item,
          :physical_item,
          :digital_item
        ].sample
      end
      let :params do
        {
          storefront_item: FactoryGirl.build(
            :storefront_item,
            price: price,
            item: item
          ).attributes
        }
      end

      it 'creates new storefront item' do
        expect { send_request }.to change { StorefrontItem.count }.by(1)
        expect_status(200)
        expect_response(StorefrontItemSerializer.new(StorefrontItem.last).to_json)
      end
    end
  end

  describe 'put /storefront_items/:id' do
    let(:method) { :put }
    let(:path) { "/storefront_items/#{id}" }

    include_examples 'invalid id'

    context 'valid id' do
      let(:storefront_item) { FactoryGirl.create :storefront_item }
      let(:id) { storefront_item.id }

      context 'invalid parameters' do
        let(:params) { { storefront_item: { name: nil } } }

        include_examples 'bad request'

        it 'does not update the storefront item' do
          expect { send_request }.to_not change { storefront_item.reload.attributes }
        end
      end

      context 'valid parameters' do
        let(:params) { { storefront_item: { name: rand_str } } }

        it 'updates the the storefront item' do
          expect { send_request }.to change { storefront_item.reload.attributes }
          expect_status(200)
          expect_response(StorefrontItemSerializer.new(storefront_item).to_json)
        end
      end
    end
  end

  describe 'put /storefront_items/:id/activate' do
    let(:method) { :put }
    let(:path) { "/storefront_items/#{id}/activate" }

    include_examples 'invalid id'

    context 'valid id' do
      let(:storefront_item) { FactoryGirl.create :storefront_item }
      let(:id) { storefront_item.id }

      context 'activated storefront item' do
        before :each do
          expect(storefront_item).to be_active
        end

        include_examples 'not found'

        it 'does not update the storefront item' do
          expect { send_request }.to_not change { storefront_item.reload.attributes }
        end
      end

      context 'unactivated storefront item' do
        before :each do
          storefront_item.deactivate!
        end

        it 'activates the storefront item' do
          expect { send_request }.to change { storefront_item.reload.active? }.to(true)
          expect_status(200)
          expect_response(StorefrontItemSerializer.new(storefront_item).to_json)
        end
      end
    end
  end

  describe 'delete /storefront_items/:id' do
    let(:method) { :delete }
    let(:path) { "/storefront_items/#{id}" }

    include_examples 'invalid id'

    context 'valid id' do
      let(:storefront_item) { FactoryGirl.create :storefront_item }
      let(:id) { storefront_item.id }

      context 'deleted storefront item' do
        before :each do
          storefront_item.delete!
        end

        include_examples 'not found'

        it 'does not update the storefront item' do
          expect { send_request }.to_not change { storefront_item.reload.attributes }
        end
      end

      context 'undeleted storefront item' do
        before :each do
          expect(storefront_item).to be_kept
        end

        it 'deletes the storefront item' do
          expect { send_request }.to change { StorefrontItem.count }.by(-1)
          expect_status(200)
          expect_response(StorefrontItemSerializer.new(storefront_item.reload).to_json)
        end
      end
    end
  end
end
