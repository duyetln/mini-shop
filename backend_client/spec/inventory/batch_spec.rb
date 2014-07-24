require 'spec_setup'
require 'spec/base'

describe BackendClient::Batch do
  include_examples 'backend client'
  include_examples 'default find'
  include_examples 'default update'
  include_examples 'default activate'
  include_examples 'default delete'

  describe '#coupons' do
    context 'not paginated' do
      it 'returns coupons' do
        expect_get("/#{model.id}/coupons", {}, collection(coupon_payload))
        expect(
          model.coupons.map(&:class).uniq
        ).to contain_exactly(BackendClient::Coupon)
      end
    end

    context 'paginated' do
      let(:page) { 1 }
      let(:size) { qty }
      let(:padn) { rand_num }
      let(:params) { { page: page, size: size, padn: padn } }

      it 'returns paginated coupons' do
        expect_get("/#{model.id}/coupons", { params: params }, collection(coupon_payload))
        expect(
          model.coupons(params).map(&:class).uniq
        ).to contain_exactly(BackendClient::Coupon)
      end
    end
  end

  describe '.create_coupons' do
    it 'creates coupons' do
      expect_post("/#{model.id}/coupons/generate", qty: qty)
      expect { model.create_coupons(qty) }.to change { model.attributes }
    end
  end
end
