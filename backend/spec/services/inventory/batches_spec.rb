require 'services/spec_setup'
require 'spec/services/shared/errors'

describe Services::Inventory::Batches do
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
