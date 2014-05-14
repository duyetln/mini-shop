require 'services/spec_setup'
require 'spec/services/shared/errors'

describe Services::Inventory::BundleItems do
  describe 'get /bundle_items' do
    let(:method) { :get }
    let(:path) { '/bundle_items' }

    before :each do
      FactoryGirl.create :bundle_item
    end

    it 'returns all bundle items' do
      send_request
      expect_status(200)
      expect_response(BundleItem.all.map do |item|
        BundleItemSerializer.new(item)
      end.to_json)
    end
  end

  describe 'post /bundle_items' do
    let(:method) { :post }
    let(:path) { '/bundle_items' }

    context 'invalid parameters' do
      let(:params) { {} }

      include_examples 'bad request'

      it 'does not create new bundle item' do
        expect { send_request }.to_not change { BundleItem.count }
      end
    end

    context 'valid parameters' do
      let(:params) { { bundle_item: FactoryGirl.build(:bundle_item).attributes } }

      it 'creates new bundle item' do
        expect { send_request }.to change { BundleItem.count }.by(1)
        expect_status(200)
        expect_response(BundleItemSerializer.new(BundleItem.last).to_json)
      end
    end
  end

  describe 'put /bundle_items/:id' do
    let(:method) { :put }
    let(:path) { "/bundle_items/#{id}" }

    include_examples 'invalid id'

    context 'valid id' do
      let(:bundle_item) { FactoryGirl.create :bundle_item }
      let(:id) { bundle_item.id }

      context 'invalid parameters' do
        let(:params) { { bundle_item: { title: nil } } }

        include_examples 'bad request'

        it 'does not update the bundle item' do
          expect { send_request }.to_not change { bundle_item.reload.attributes }
        end
      end

      context 'valid parameters' do
        let(:params) { { bundle_item: { title: rand_str } } }

        it 'updates the the bundle item' do
          expect { send_request }.to change { bundle_item.reload.attributes }
          expect_status(200)
          expect_response(BundleItemSerializer.new(bundle_item).to_json)
        end
      end
    end
  end

  describe 'post /bundle_items/:id/bundlings' do
    let(:method) { :post }
    let(:path) { "/bundle_items/#{id}/bundlings" }

    include_examples 'invalid id'

    context 'valid id' do
      let(:bundle_item) { FactoryGirl.create :bundle_item }
      let(:id) { bundle_item.id }
      let(:item) { FactoryGirl.create [:physical_item, :digital_item].sample }
      let(:item_type) { item.class.name }
      let(:item_id) { item.id }
      let :params do
        {
          bundling: {
            item_type: item_type,
            item_id: item_id,
            qty: qty
          }
        }
      end

      context 'invalid item type' do
        let(:item_type) { rand_str }

        include_examples 'bad request'
      end

      context 'invalid item id' do
        let(:item_id) { rand_str }

        include_examples 'not found'
      end

      context 'valid parameters' do
        it 'creates new bundling' do
          expect { send_request }.to change { bundle_item.bundlings.count }.by(1)
          expect_status(200)
          expect_response(BundleItemSerializer.new(bundle_item).to_json)
        end

        it 'sets bundling attributes correctly' do
          send_request
          order = bundle_item.bundlings.last
          expect(order.item).to eq(item)
          expect(order.qty).to eq(qty)
        end
      end
    end
  end

  describe 'delete /bundle_items/:id/bundlings/:bundling_id' do
    let(:method) { :delete }
    let(:path) { "/bundle_items/#{id}/bundlings/#{bundling_id}" }
    let(:bundling_id) { rand_str }

    include_examples 'invalid id'

    context 'valid id' do
      let(:bundle_item) { FactoryGirl.create :bundle_item }
      let(:id) { bundle_item.id }

      context 'invalid bundling id' do
        include_examples 'not found'
      end

      context 'valid bundling id' do
        let(:item) { FactoryGirl.create [:physical_item, :digital_item].sample }
        let(:bundling) { bundle_item.bundlings.last }
        let(:bundling_id) { bundling.id }

        before :each do
          bundle_item.add_or_update(item, qty)
        end

        it 'removes the bundling' do
          expect { send_request }.to change { bundle_item.bundlings.count }.by(-1)
          expect_status(200)
          expect_response(BundleItemSerializer.new(bundle_item).to_json)
        end
      end
    end
  end

  describe 'put /bundle_items/:id/activate' do
    let(:method) { :put }
    let(:path) { "/bundle_items/#{id}/activate" }

    include_examples 'invalid id'

    context 'valid id' do
      let(:bundle_item) { FactoryGirl.create :bundle_item }
      let(:id) { bundle_item.id }

      context 'activated bundle item' do
        before :each do
          expect(bundle_item).to be_active
        end

        include_examples 'not found'

        it 'does not update the bundle item' do
          expect { send_request }.to_not change { bundle_item.reload.attributes }
        end
      end

      context 'unactivated bundle item' do
        before :each do
          bundle_item.deactivate!
        end

        it 'activates the bundle item' do
          expect { send_request }.to change { bundle_item.reload.active? }.to(true)
          expect_status(200)
          expect_response(BundleItemSerializer.new(bundle_item).to_json)
        end
      end
    end
  end

  describe 'delete /bundle_items/:id' do
    let(:method) { :delete }
    let(:path) { "/bundle_items/#{id}" }

    include_examples 'invalid id'

    context 'valid id' do
      let(:bundle_item) { FactoryGirl.create :bundle_item }
      let(:id) { bundle_item.id }

      context 'deleted bundle item' do
        before :each do
          bundle_item.delete!
        end

        include_examples 'not found'

        it 'does not update the bundle item' do
          expect { send_request }.to_not change { bundle_item.reload.attributes }
        end
      end

      context 'undeleted bundle item' do
        before :each do
          expect(bundle_item).to be_kept
        end

        it 'deletes the bundle item' do
          expect { send_request }.to change { BundleItem.count }.by(-1)
          expect_status(200)
          expect_response(BundleItemSerializer.new(bundle_item.reload).to_json)
        end
      end
    end
  end
end
