require 'spec_setup'

describe BackendClient::Coupon do
  include_examples 'api resource'
  include_examples 'api model'
  include_examples 'default find'

  describe '.initialize' do
    it 'sets used_at correctly' do
      expect(
        full_model.used_at
      ).to be_instance_of(DateTime)
    end
  end

  describe '.promotion' do
    let(:promotion) { BackendClient::Promotion.instantiate parse(promotion_payload) }

    before :each do
      bare_model.promotion_id = rand_str
    end

    it 'returns promotion' do
      expect(BackendClient::Promotion).to receive(:find).with(bare_model.promotion_id).and_return(promotion)
      expect(bare_model.promotion).to eq(promotion)
    end
  end
end
