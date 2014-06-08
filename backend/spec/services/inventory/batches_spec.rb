require 'services/spec_setup'
require 'spec/services/shared/errors'

describe Services::Inventory::Batches do
  describe 'get /promotions/:id/batches' do
    let(:method) { :get }
    let(:path) { "/promotions/#{id}/batches" }

    include_examples 'invalid id'

    context 'valid id' do
      let(:promotion) { FactoryGirl.create :promotion, :coupons }
      let(:id) { promotion.id }

      it 'returns all promotions' do
        send_request
        expect_status(200)
        expect_response(promotion.batches.map do |batch|
          BatchSerializer.new(batch)
        end.to_json)
      end
    end
  end

  describe 'post /promotions/:id/batches' do
    let(:method) { :post }
    let(:path) { "/promotions/#{id}/batches" }

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

  describe 'post /promotions/:id/batches/generate' do
    let(:method) { :post }
    let(:path) { "/promotions/#{id}/batches/generate" }

    include_examples 'invalid id'

    context 'valid id' do
      let(:promotion) { FactoryGirl.create :promotion }
      let(:id) { promotion.id }
      let(:qty) { 10 }
      let(:size) { 3 }
      let(:batch_num) { (qty.to_f / size).ceil }
      let :params do
        {
          qty: qty,
          batch: {
            size: size,
            name: 'batch name'
          }
        }
      end

      it 'creates new batch' do
        expect { send_request }.to change { promotion.batches.count }.by(batch_num)
        expect_status(200)
        expect_response(promotion.batches.last(batch_num).map do |batch|
          BatchSerializer.new(batch)
        end.to_json)
      end

      it 'sets batch attributes correctly' do
        send_request
        batches = promotion.batches.last(batch_num)
        batches[0...(batches.size - 1)].each do |batch|
          expect(batch.coupons.count).to eq(size)
        end
        expect(batches.last.coupons.count).to eq(qty % size)
      end
    end
  end

  describe 'get /batches/:id/coupons' do
    let(:method) { :get }
    let(:path) { "/batches/#{id}/coupons" }

    include_examples 'invalid id'

    context 'valid id' do
      let(:batch) { FactoryGirl.create :batch, :coupons }
      let(:id) { batch.id }

      it 'returns all coupons' do
        send_request
        expect_status(200)
        expect_response(batch.coupons.map do |coupon|
          CouponSerializer.new(coupon)
        end.to_json)
      end
    end
  end

  describe 'put /batches/:id/activate' do
    let(:method) { :put }
    let(:path) { "/batches/#{id}/activate" }

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

  describe 'delete /batches/:id' do
    let(:method) { :delete }
    let(:path) { "/batches/#{id}" }

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
