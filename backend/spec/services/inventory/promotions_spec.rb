require 'services/spec_setup'
require 'spec/services/shared/errors'

describe Services::Inventory::Promotions do
  describe 'get /' do
    let(:method) { :get }
    let(:path) { '/' }

    before :each do
      FactoryGirl.create :promotion
    end

    context 'not paginated' do
      it 'returns all promotions' do
        send_request
        expect_status(200)
        expect_response(Promotion.all.map do |promotion|
          PromotionSerializer.new(promotion)
        end.to_json)
      end
    end

    context 'paginated' do
      let(:page) { 1 }
      let(:size) { qty }
      let(:padn) { rand_num }
      let(:params) { { page: page, size: size, padn: padn } }

      it 'returns paginated promotions' do
        send_request
        expect_status(200)
        expect_response(
          Promotion.page(page,
            size: size,
            padn: padn
          ).all.map do |promotion|
            PromotionSerializer.new(promotion)
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
      let(:promotion) { FactoryGirl.create :promotion }
      let(:id) { promotion.id }

      it 'returns the user' do
        send_request
        expect_status(200)
        expect_response(PromotionSerializer.new(promotion).to_json)
      end
    end
  end

  describe 'post /' do
    let(:method) { :post }
    let(:path) { '/' }

    context 'invalid parameters' do
      let(:params) { {} }

      include_examples 'bad request'

      it 'does not create new promotion' do
        expect { send_request }.to_not change { StoreItem.count }
      end
    end

    context 'valid parameters' do
      let(:discount) { FactoryGirl.create :discount, :full }
      let(:price) { FactoryGirl.create :price, discount: discount }
      let :item do
        FactoryGirl.create [
          :bundle,
          :physical_item,
          :digital_item
        ].sample
      end
      let :params do
        {
          promotion: FactoryGirl.build(
            :promotion,
            price: price,
            item: item
          ).attributes
        }
      end

      it 'creates new promotion' do
        expect { send_request }.to change { Promotion.count }.by(1)
        expect_status(200)
        expect_response(PromotionSerializer.new(Promotion.last).to_json)
      end
    end
  end

  describe 'put /:id' do
    let(:method) { :put }
    let(:path) { "/#{id}" }

    include_examples 'invalid id'

    context 'valid id' do
      let!(:promotion) { FactoryGirl.create :promotion }
      let(:id) { promotion.id }

      context 'invalid parameters' do
        let(:params) { { promotion: { name: nil } } }

        include_examples 'bad request'

        it 'does not update the promotion' do
          expect { send_request }.to_not change { promotion.reload.attributes }
        end
      end

      context 'valid parameters' do
        let(:params) { { promotion: { name: rand_str } } }

        it 'updates the the promotion' do
          expect { send_request }.to change { promotion.reload.attributes }
          expect_status(200)
          expect_response(PromotionSerializer.new(promotion).to_json)
        end
      end
    end
  end

  describe 'put /:id/activate' do
    let(:method) { :put }
    let(:path) { "/#{id}/activate" }

    include_examples 'invalid id'

    context 'valid id' do
      let!(:promotion) { FactoryGirl.create :promotion }
      let(:id) { promotion.id }

      before :each do
        Promotion.any_instance.stub(:activable?).and_return(activable)
      end

      context 'unactivable promotion' do
        let(:activable) { false }

        include_examples 'unprocessable'

        it 'does not update the promotion' do
          expect { send_request }.to_not change { promotion.reload.attributes }
        end
      end

      context 'activable promotion' do
        let(:activable) { true }

        it 'activates the promotion' do
          expect { send_request }.to change { promotion.reload.active? }.to(true)
          expect_status(200)
          expect_response(PromotionSerializer.new(promotion).to_json)
        end
      end
    end
  end

  describe 'delete /:id' do
    let(:method) { :delete }
    let(:path) { "/#{id}" }

    include_examples 'invalid id'

    context 'valid id' do
      let!(:promotion) { FactoryGirl.create :promotion }
      let(:id) { promotion.id }

      context 'deleted promotion' do
        before :each do
          expect { promotion.delete! }.to change { promotion.deleted? }.to true
        end

        include_examples 'not found'

        it 'does not update the promotion' do
          expect { send_request }.to_not change { promotion.reload.attributes }
        end
      end

      context 'non deleted promotion' do
        before :each do
          Promotion.any_instance.stub(:deletable?).and_return(deletable)
        end

        context 'deletable promotion' do
          let(:deletable) { false }

          include_examples 'unprocessable'

          it 'does not update the promotion' do
            expect { send_request }.to_not change { promotion.reload.attributes }
          end
        end

        context 'deletable promotion' do
          let(:deletable) { true }

          it 'deletes the promotion' do
            expect { send_request }.to change { Promotion.count }.by(-1)
            expect_status(200)
            expect_response(PromotionSerializer.new(promotion.reload).to_json)
          end
        end
      end
    end
  end

  describe 'get /:id/batches' do
    let(:method) { :get }
    let(:path) { "/#{id}/batches" }

    include_examples 'invalid id'

    context 'valid id' do
      let(:promotion) { FactoryGirl.create :promotion, :coupons }
      let(:id) { promotion.id }

      context 'not paginated' do
        it 'returns all batches' do
          send_request
          expect_status(200)
          expect_response(promotion.batches.map do |batch|
            BatchSerializer.new(batch)
          end.to_json)
        end
      end

      context 'paginated' do
        let(:page) { 1 }
        let(:size) { qty }
        let(:padn) { rand_num }
        let(:params) { { page: page, size: size, padn: padn } }

        it 'returns all batches' do
          send_request
          expect_status(200)
          expect_response(
            promotion.batches.page(page,
              size: size,
              padn: padn
            ).all.map do |batch|
              BatchSerializer.new(batch)
            end.to_json
          )
        end
      end
    end
  end

  describe 'post /:id/batches' do
    let(:method) { :post }
    let(:path) { "/#{id}/batches" }

    include_examples 'invalid id'

    context 'valid id' do
      let(:promotion) { FactoryGirl.create :promotion }
      let(:id) { promotion.id }
      let :params do
        {
          batch: {
            size: 10,
            name: 'batch name'
          }
        }
      end

      it 'creates new batch' do
        expect { send_request }.to change { promotion.batches.count }.by(1)
        expect_status(200)
        expect_response(BatchSerializer.new(promotion.batches.last).to_json)
      end

      it 'sets batch attributes correctly' do
        send_request
        batch = promotion.batches.last
        expect(batch.coupons.count).to eq(params[:batch][:size])
        expect(batch.name).to eq(params[:batch][:name])
      end
    end
  end

  describe 'post /:id/batches/generate' do
    let(:method) { :post }
    let(:path) { "/#{id}/batches/generate" }

    include_examples 'invalid id'

    context 'valid id' do
      let(:promotion) { FactoryGirl.create :promotion }
      let(:id) { promotion.id }
      let(:qty) { 10 }
      let(:size) { 3 }
      let :params do
        {
          qty: qty,
          batch: {
            size: size
          }
        }
      end

      it 'creates new batch' do
        expect { send_request }.to change { promotion.batches.count }.by(qty)
        expect_status(200)
        expect_response(promotion.batches.last(qty).map do |batch|
          BatchSerializer.new(batch)
        end.to_json)
      end

      it 'sets batch attributes correctly' do
        send_request
        promotion.batches.last(qty).each do |batch|
          expect(batch.coupons.count).to eq(size)
        end
      end
    end
  end
end
