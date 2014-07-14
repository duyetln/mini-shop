require 'services/spec_setup'
require 'spec/services/shared/errors'

describe Services::Inventory::Batches do
  describe 'get /:id/coupons' do
    let(:method) { :get }
    let(:path) { "/#{id}/coupons" }

    include_examples 'invalid id'

    context 'valid id' do
      let(:batch) { FactoryGirl.create :batch, :coupons }
      let(:id) { batch.id }

      context 'not paginated' do
        it 'returns all coupons' do
          send_request
          expect_status(200)
          expect_response(batch.coupons.map do |coupon|
            CouponSerializer.new(coupon)
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
            batch.coupons.page(page,
              size: size,
              padn: padn
            ).all.map do |coupon|
              CouponSerializer.new(coupon)
            end.to_json
          )
        end
      end
    end
  end

  describe 'post /:id/coupons/generate' do
    let(:method) { :post }
    let(:path) { "/#{id}/coupons/generate" }

    include_examples 'invalid id'

    context 'valid id' do
      let(:batch) { FactoryGirl.create :batch }
      let(:id) { batch.id }
      let(:qty) { 10 }
      let(:params) { { qty: qty } }

      it 'creates coupons' do
        expect { send_request }.to change { batch.coupons.count }.by(qty)
        expect_status(200)
        expect_response(BatchSerializer.new(batch).to_json)
      end
    end
  end

  describe 'put /:id' do
    let(:method) { :put }
    let(:path) { "/#{id}" }

    include_examples 'invalid id'

    context 'valid id' do
      let!(:batch) { FactoryGirl.create :batch }
      let(:id) { batch.id }

      context 'invalid parameters' do
        let(:params) { { batch: { name: nil } } }

        include_examples 'bad request'

        it 'does not update the promotion' do
          expect { send_request }.to_not change { batch.reload.attributes }
        end
      end

      context 'valid parameters' do
        let(:params) { { batch: { name: rand_str } } }

        it 'updates the the promotion' do
          expect { send_request }.to change { batch.reload.attributes }
          expect_status(200)
          expect_response(BatchSerializer.new(batch).to_json)
        end
      end
    end
  end

  describe 'put /:id/activate' do
    let(:method) { :put }
    let(:path) { "/#{id}/activate" }

    include_examples 'invalid id'

    context 'valid id' do
      let!(:batch) { FactoryGirl.create :batch }
      let(:id) { batch.id }

      before :each do
        Batch.any_instance.stub(:activable?).and_return(activable)
      end

      context 'unactivable batch' do
        let(:activable) { false }

        include_examples 'unprocessable'

        it 'does not update the batch' do
          expect { send_request }.to_not change { batch.reload.attributes }
        end
      end

      context 'activable batch' do
        let(:activable) { true }

        it 'activates the batch' do
          expect { send_request }.to change { batch.reload.active? }.to(true)
          expect_status(200)
          expect_response(BatchSerializer.new(batch).to_json)
        end
      end
    end
  end

  describe 'delete /:id' do
    let(:method) { :delete }
    let(:path) { "/#{id}" }

    include_examples 'invalid id'

    context 'valid id' do
      let!(:batch) { FactoryGirl.create :batch }
      let(:id) { batch.id }

      context 'deleted batch' do
        before :each do
          expect { batch.delete! }.to change { batch.deleted? }.to true
        end

        include_examples 'not found'

        it 'does not update the batch' do
          expect { send_request }.to_not change { batch.reload.attributes }
        end
      end

      context 'non deleted batch' do
        before :each do
          Batch.any_instance.stub(:deletable?).and_return(deletable)
        end

        context 'deletable batch' do
          let(:deletable) { false }

          include_examples 'unprocessable'

          it 'does not update the batch' do
            expect { send_request }.to_not change { batch.reload.attributes }
          end
        end

        context 'deletable batch' do
          let(:deletable) { true }

          it 'deletes the batch' do
            expect { send_request }.to change { Batch.count }.by(-1)
            expect_status(200)
            expect_response(BatchSerializer.new(batch.reload).to_json)
          end
        end
      end
    end
  end
end
