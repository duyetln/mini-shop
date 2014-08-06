require 'spec_setup'

describe BackendClient::Price do
  include_examples 'api resource'
  include_examples 'api model'
  include_examples 'default find'
  include_examples 'default create'
  include_examples 'default update'

  describe '.initialize' do
    it 'sets pricepoint correctly' do
      expect(
        full_model.pricepoint
      ).to be_instance_of(BackendClient::Pricepoint)
    end

    it 'sets discount correctly' do
      expect(
        full_model.discount
      ).to be_instance_of(BackendClient::Discount)
    end
  end

  describe '#amount' do
    let(:currency) { BackendClient::Currency.instantiate(parse(currency_payload)) }

    it 'returns amount correctly' do
      zero = BigDecimal.new('0.0')
      expected_amount = (full_model.pricepoint.amount(currency) || zero) * (1 - (full_model.discount.try(:current_rate) || zero))
      expect(full_model.amount(currency)).to eq(expected_amount)
    end
  end
end
