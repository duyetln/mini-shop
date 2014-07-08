require 'spec_setup'
require 'spec/base'

describe BackendClient::Batch do
  include_examples 'backend client'
  include_examples 'default update'
  include_examples 'default activate'
  include_examples 'default delete'

  describe '#coupons' do
    let(:association) { :coupons }
    let(:association_class) { BackendClient::Coupon }
    let(:association_payload) { coupon_payload }

    it 'returns association collection' do
      expect_get("/#{model.id}/#{association}", {}, collection(association_payload))
      expect(
        model.send(association).map(&:class).uniq
      ).to contain_exactly(association_class)
    end
  end

  describe '.create_coupons' do
    it 'creates coupons' do
      expect_post("/#{model.id}/coupons/generate", qty: qty)
      expect { model.create_coupons(qty) }.to change { model.attributes }
    end
  end
end
