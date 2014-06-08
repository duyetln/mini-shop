require 'services/spec_setup'
require 'spec/services/shared/errors'

describe Services::Inventory::Coupons do
  describe 'get /coupons/:code' do
    let(:method) { :get }
    let(:path) { "/coupons/#{code}" }

    context 'invalid code' do
      let(:code) { rand_str }

      include_examples 'not found'
    end

    context 'valid code' do
      let(:coupon) { FactoryGirl.create :coupon }
      let(:code) { coupon.code }

      context 'deleted promotion' do
        before :each do
          expect { coupon.promotion.delete! }.to change { coupon.promotion.deleted? }.to(true)
        end

        include_examples 'not found'
      end

      context 'deleted batch' do
        before :each do
          expect { coupon.batch.delete! }.to change { coupon.batch.deleted? }.to(true)
        end

        include_examples 'not found'
      end

      context 'non deleted promotion, non deleted batch' do
        before :each do
          expect(coupon.batch).to_not be_deleted
          expect(coupon.promotion).to_not be_deleted
        end

        it 'returns the coupon' do
          send_request
          expect_status(200)
          expect_response(CouponSerializer.new(coupon).to_json)
        end
      end
    end
  end
end
