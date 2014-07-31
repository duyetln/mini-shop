require 'spec_setup'

describe BackendClient::PricepointPrice do
  include_examples 'api resource'
  include_examples 'api model'
  include_examples 'default update'

  describe '.initialize' do
    it 'sets currency correctly' do
      expect(
        full_model.currency
      ).to be_instance_of(BackendClient::Currency)
    end

    it 'sets amount correctly' do
      expect(
        full_model.amount
      ).to be_instance_of(BigDecimal)
    end
  end
end
