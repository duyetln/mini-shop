require 'spec_setup'
require 'spec/base'

describe BackendClient::Coupon do
  include_examples 'backend client'

  describe '.instantiate' do
    let(:model) { instantiated_model }

    it 'sets bundleds correctly' do
      expect(
        model.used_at
      ).to be_instance_of(DateTime)
    end
  end

  describe '.find_by_code' do
    let(:code) { rand_str }

    it 'finds coupon with code' do
      expect_get("/#{code}")
      expect(
        described_class.find_by_code(code)
      ).to be_instance_of(described_class)
    end
  end

  describe '.promotion' do
    let(:promotion) { BackendClient::Promotion.new }
    let(:model) { described_class.new promotion_id: rand_str }

    it 'returns promotion' do
      expect(BackendClient::Promotion).to receive(:find).with(model.promotion_id).and_return(promotion)
      expect(model.promotion).to eq(promotion)
    end
  end
end
