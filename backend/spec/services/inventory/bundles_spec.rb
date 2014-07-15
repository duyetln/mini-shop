require 'services/spec_setup'
require 'spec/services/shared/errors'

describe Services::Inventory::Bundles do
  describe 'get /' do
    let(:method) { :get }
    let(:path) { '/' }

    before :each do
      FactoryGirl.create :bundle
    end

    context 'not paginated' do
      it 'returns all bundles' do
        send_request
        expect_status(200)
        expect_response(Bundle.all.map do |item|
          BundleSerializer.new(item)
        end.to_json)
      end
    end

    context 'paginated' do
      let(:page) { 1 }
      let(:size) { qty }
      let(:padn) { rand_num }
      let(:params) { { page: page, size: size, padn: padn } }

      it 'returns paginated bundles' do
        send_request
        expect_status(200)
        expect_response(
          Bundle.page(page,
                      size: size,
                      padn: padn
          ).all.map do |item|
            BundleSerializer.new(item)
          end.to_json
        )
      end
    end
  end

  describe 'get /:id' do
    let(:method) { :get }
    let(:path) { "/#{id}" }

    include_examples 'invalid id'

    context 'valid id' do
      let(:bundle) { FactoryGirl.create :bundle }
      let(:id) { bundle.id }

      it 'returns the user' do
        send_request
        expect_status(200)
        expect_response(BundleSerializer.new(bundle).to_json)
      end
    end
  end

  describe 'post /' do
    let(:method) { :post }
    let(:path) { '/' }

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

  describe 'put /:id' do
    let(:method) { :put }
    let(:path) { "/#{id}" }

    include_examples 'invalid id'

    context 'valid id' do
      let!(:bundle) { FactoryGirl.create :bundle }
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

  describe 'post /:id/bundleds' do
    let(:method) { :post }
    let(:path) { "/#{id}/bundleds" }

    include_examples 'invalid id'

    context 'valid id' do
      let(:bundle) { FactoryGirl.create :bundle, :bundleds }
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

      context 'activated bundle' do
        before :each do
          expect do
            bundle.items.each(&:activate!)
            bundle.activate!
          end.to change { bundle.active? }.to(true)
        end

        include_examples 'unprocessable'
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

  describe 'delete /:id/bundleds/:bundled_id' do
    let(:method) { :delete }
    let(:path) { "/#{id}/bundleds/#{bundled_id}" }
    let(:bundled_id) { rand_str }

    include_examples 'invalid id'

    context 'valid id' do
      let!(:bundle) { FactoryGirl.create :bundle }
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

        context 'activated bundle' do
          before :each do
            expect do
              bundle.items.each(&:activate!)
              bundle.activate!
            end.to change { bundle.active? }.to(true)
          end

          include_examples 'unprocessable'
        end

        context 'unactivated bundle' do
          it 'removes the bundled' do
            expect { send_request }.to change { bundle.bundleds.count }.by(-1)
            expect_status(200)
            expect_response(BundleSerializer.new(bundle).to_json)
          end
        end
      end
    end
  end

  describe 'put /:id/activate' do
    let(:method) { :put }
    let(:path) { "/#{id}/activate" }

    include_examples 'invalid id'

    context 'valid id' do
      let!(:bundle) { FactoryGirl.create :bundle }
      let(:id) { bundle.id }

      before :each do
        Bundle.any_instance.stub(:activable?).and_return(activable)
      end

      context 'unactivable bundle' do
        let(:activable) { false }

        include_examples 'unprocessable'

        it 'does not update the bundle' do
          expect { send_request }.to_not change { bundle.reload.attributes }
        end
      end

      context 'activable bundle' do
        let(:activable) { true }

        it 'activates the bundle' do
          expect { send_request }.to change { bundle.reload.active? }.to(true)
          expect_status(200)
          expect_response(BundleSerializer.new(bundle).to_json)
        end
      end
    end
  end

  describe 'delete /:id' do
    let(:method) { :delete }
    let(:path) { "/#{id}" }

    include_examples 'invalid id'

    context 'valid id' do
      let!(:bundle) { FactoryGirl.create :bundle }
      let(:id) { bundle.id }

      context 'deleted bundle' do
        before :each do
          expect { bundle.delete! }.to change { bundle.deleted? }.to(true)
        end

        include_examples 'not found'

        it 'does not update the bundle' do
          expect { send_request }.to_not change { bundle.reload.attributes }
        end
      end

      context 'non deleted bundle' do
        before :each do
          Bundle.any_instance.stub(:deletable?).and_return(deletable)
        end

        context 'deletable bundle' do
          let(:deletable) { false }

          include_examples 'unprocessable'

          it 'does not update the bundle' do
            expect { send_request }.to_not change { bundle.reload.attributes }
          end
        end

        context 'deletable bundle' do
          let(:deletable) { true }

          it 'deletes the bundle' do
            expect { send_request }.to change { Bundle.count }.by(-1)
            expect_status(200)
            expect_response(BundleSerializer.new(bundle.reload).to_json)
          end
        end
      end
    end
  end
end
