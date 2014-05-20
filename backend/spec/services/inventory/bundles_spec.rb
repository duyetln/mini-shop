require 'services/spec_setup'
require 'spec/services/shared/errors'

describe Services::Inventory::Bundles do
  describe 'get /bundles' do
    let(:method) { :get }
    let(:path) { '/bundles' }

    before :each do
      FactoryGirl.create :bundle
    end

    it 'returns all bundles' do
      send_request
      expect_status(200)
      expect_response(Bundle.all.map do |item|
        BundleSerializer.new(item)
      end.to_json)
    end
  end

  describe 'post /bundles' do
    let(:method) { :post }
    let(:path) { '/bundles' }

    context 'invalid parameters' do
      let(:params) { {} }

      include_examples 'bad request'

      it 'does not create new bundle' do
        expect { send_request }.to_not change { Bundle.count }
      end
    end

    context 'valid parameters' do
      let(:params) { { bundle: FactoryGirl.build(:bundle).attributes } }

      it 'creates new bundle' do
        expect { send_request }.to change { Bundle.count }.by(1)
        expect_status(200)
        expect_response(BundleSerializer.new(Bundle.last).to_json)
      end
    end
  end

  describe 'put /bundles/:id' do
    let(:method) { :put }
    let(:path) { "/bundles/#{id}" }

    include_examples 'invalid id'

    context 'valid id' do
      let(:bundle) { FactoryGirl.create :bundle }
      let(:id) { bundle.id }

      context 'invalid parameters' do
        let(:params) { { bundle: { title: nil } } }

        include_examples 'bad request'

        it 'does not update the bundle' do
          expect { send_request }.to_not change { bundle.reload.attributes }
        end
      end

      context 'valid parameters' do
        let(:params) { { bundle: { title: rand_str } } }

        it 'updates the bundle' do
          expect { send_request }.to change { bundle.reload.attributes }
          expect_status(200)
          expect_response(BundleSerializer.new(bundle).to_json)
        end
      end
    end
  end

  describe 'post /bundles/:id/bundleds' do
    let(:method) { :post }
    let(:path) { "/bundles/#{id}/bundleds" }

    include_examples 'invalid id'

    context 'valid id' do
      let(:bundle) { FactoryGirl.create :bundle }
      let(:id) { bundle.id }
      let(:item) { FactoryGirl.create [:physical_item, :digital_item].sample }
      let(:item_type) { item.class.name }
      let(:item_id) { item.id }
      let :params do
        {
          bundled: {
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
        it 'creates new bundled' do
          expect { send_request }.to change { bundle.bundleds.count }.by(1)
          expect_status(200)
          expect_response(BundleSerializer.new(bundle).to_json)
        end

        it 'sets bundled attributes correctly' do
          send_request
          order = bundle.bundleds.last
          expect(order.item).to eq(item)
          expect(order.qty).to eq(qty)
        end
      end
    end
  end

  describe 'delete /bundles/:id/bundleds/:bundled_id' do
    let(:method) { :delete }
    let(:path) { "/bundles/#{id}/bundleds/#{bundled_id}" }
    let(:bundled_id) { rand_str }

    include_examples 'invalid id'

    context 'valid id' do
      let(:bundle) { FactoryGirl.create :bundle }
      let(:id) { bundle.id }

      context 'invalid bundled id' do
        include_examples 'not found'
      end

      context 'valid bundled id' do
        let(:item) { FactoryGirl.create [:physical_item, :digital_item].sample }
        let(:bundled) { bundle.bundleds.last }
        let(:bundled_id) { bundled.id }

        before :each do
          bundle.add_or_update(item, qty)
        end

        it 'removes the bundled' do
          expect { send_request }.to change { bundle.bundleds.count }.by(-1)
          expect_status(200)
          expect_response(BundleSerializer.new(bundle).to_json)
        end
      end
    end
  end

  describe 'delete /bundles/:id' do
    let(:method) { :delete }
    let(:path) { "/bundles/#{id}" }

    include_examples 'invalid id'

    context 'valid id' do
      let(:bundle) { FactoryGirl.create :bundle }
      let(:id) { bundle.id }

      context 'deleted bundle' do
        before :each do
          bundle.delete!
        end

        include_examples 'not found'

        it 'does not update the bundle' do
          expect { send_request }.to_not change { bundle.reload.attributes }
        end
      end

      context 'undeleted bundle' do
        before :each do
          expect(bundle).to be_kept
        end

        it 'deletes the bundle' do
          expect { send_request }.to change { Bundle.count }.by(-1)
          expect_status(200)
          expect_response(BundleSerializer.new(bundle.reload).to_json)
        end
      end
    end
  end
end
