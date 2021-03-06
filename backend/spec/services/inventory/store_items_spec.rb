require 'services/spec_setup'

describe Services::Inventory::StoreItems do
  describe 'get /' do
    let(:method) { :get }
    let(:path) { '/' }

    before :each do
      FactoryGirl.create :store_item
    end

    context 'pagination' do
      let(:scope) { StoreItem }
      let(:serializer) { StoreItemSerializer }

      include_examples 'pagination'
    end
  end

  describe 'get /:id' do
    let(:method) { :get }
    let(:path) { "/#{id}" }

    include_examples 'invalid id'

    context 'valid id' do
      let(:store_item) { FactoryGirl.create :store_item }
      let(:id) { store_item.id }

      it 'returns the store item' do
        send_request
        expect_status(200)
        expect_response(StoreItemSerializer.new(store_item).to_json)
      end
    end
  end

  describe 'post /' do
    let(:method) { :post }
    let(:path) { '/' }

    context 'invalid parameters' do
      let(:params) { {} }

      include_examples 'bad request'

      it 'does not create new store item' do
        expect { send_request }.to_not change { StoreItem.count }
      end
    end

    context 'valid parameters' do
      let(:price) { FactoryGirl.create :price, :discounted }
      let :item do
        FactoryGirl.create [
          :bundle,
          :physical_item,
          :digital_item
        ].sample
      end
      let :params do
        {
          store_item: FactoryGirl.build(
            :store_item,
            price: price,
            item: item
          ).attributes
        }
      end

      it 'creates new store item' do
        expect { send_request }.to change { StoreItem.count }.by(1)
        expect_status(200)
        expect_response(StoreItemSerializer.new(StoreItem.last).to_json)
      end
    end
  end

  describe 'put /:id' do
    let(:method) { :put }
    let(:path) { "/#{id}" }

    include_examples 'invalid id'

    context 'valid id' do
      let!(:store_item) { FactoryGirl.create :store_item }
      let(:id) { store_item.id }

      context 'invalid parameters' do
        let(:params) { { store_item: { name: nil } } }

        include_examples 'bad request'

        it 'does not update the store item' do
          expect { send_request }.to_not change { store_item.reload.attributes }
        end
      end

      context 'valid parameters' do
        let(:params) { { store_item: { name: rand_str } } }

        it 'updates the the store item' do
          expect { send_request }.to change { store_item.reload.attributes }
          expect_status(200)
          expect_response(StoreItemSerializer.new(store_item).to_json)
        end
      end
    end
  end

  describe 'delete /:id' do
    let(:method) { :delete }
    let(:path) { "/#{id}" }

    include_examples 'invalid id'

    context 'valid id' do
      let!(:store_item) { FactoryGirl.create :store_item }
      let(:id) { store_item.id }

      context 'deleted store item' do
        before :each do
          expect { store_item.delete! }.to change { store_item.deleted? }.to(true)
        end

        include_examples 'not found'

        it 'does not update the store item' do
          expect { send_request }.to_not change { store_item.reload.attributes }
        end
      end

      context 'undeleted store item' do
        before :each do
          expect(store_item).to be_kept
        end

        it 'deletes the store item' do
          expect { send_request }.to change { StoreItem.count }.by(-1)
          expect_status(200)
          expect_response(StoreItemSerializer.new(store_item.reload).to_json)
        end
      end
    end
  end
end
