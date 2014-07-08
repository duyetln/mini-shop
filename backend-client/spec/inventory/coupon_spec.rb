require 'spec_setup'
require 'spec/base'

describe BackendClient::Coupon do
  include_examples 'backend client'

  describe '.instantiate' do
    let(:model) { described_class.instantiate(parse(resource_payload)) }

    it 'sets bundleds correctly' do
      expect(model.used_at).to be_an_instance_of(DateTime)
    end
  end

  describe '.find_by_code' do
    let(:code) { Faker::Lorem.characters(16) }

    it 'finds coupon with code' do
      expect(described_class.resource).to receive(:[]).with("/#{code}").and_return(doubled_resource)
      expect(doubled_resource).to receive(:get).and_return(resource_payload)
      expect(described_class.find_by_code(code)).to be_an_instance_of(described_class)
    end
  end

  describe '.promotion' do
    let(:promotion) { BackendClient::Promotion.new }
    let(:promotion_id) { :promotion_id }
    let(:model) { described_class.new promotion_id: promotion_id }

    it 'returns promotion' do
      expect(BackendClient::Promotion).to receive(:find).with(promotion_id).and_return(promotion)
      expect(model.promotion).to eq(promotion)
    end
  end
end
