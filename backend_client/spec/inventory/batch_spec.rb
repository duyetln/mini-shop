require 'spec_setup'

describe BackendClient::Batch do
  include_examples 'api resource'
  include_examples 'api model'
  include_examples 'default find'
  include_examples 'default update'
  include_examples 'default activate'
  include_examples 'default delete'

  describe '#coupons' do
    context 'not paginated' do
      it 'returns coupons' do
        expect_http_action(:get, { path: "/#{bare_model.id}/coupons", payload: {} }, [parse(coupon_payload)])
        expect(
          bare_model.coupons.map(&:class).uniq
        ).to contain_exactly(BackendClient::Coupon)
      end
    end

    context 'paginated' do
      let(:page) { 1 }
      let(:size) { qty }
      let(:padn) { rand_num }
      let(:sort) { :asc }
      let(:params) { { page: page, size: size, padn: padn, sort: sort } }

      it 'returns paginated coupons' do
        expect_http_action(:get, { path: "/#{bare_model.id}/coupons", payload: params }, [parse(coupon_payload)])
        expect(
          bare_model.coupons(params).map(&:class).uniq
        ).to contain_exactly(BackendClient::Coupon)
      end
    end
  end

  describe '#promotion' do
    let(:promotion) { BackendClient::Promotion.instantiate parse(promotion_payload) }

    before :each do
      bare_model.promotion_id = rand_str
    end

    it 'returns promotion' do
      expect(BackendClient::Promotion).to receive(:find).with(bare_model.promotion_id).and_return(promotion)
      expect(bare_model.promotion).to eq(promotion)
    end
  end

  describe '.create_coupons' do
    it 'creates coupons' do
      expect_http_action(:post, { path: "/#{bare_model.id}/coupons/generate", payload: { qty: qty } })
      expect { bare_model.create_coupons(qty) }.to change { bare_model.send(:attributes) }
    end
  end
end
