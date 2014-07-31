require 'spec_setup'

describe BackendClient::PaymentMethod do
  include_examples 'api resource'
  include_examples 'api model'
  include_examples 'default update'

  describe '.initialize' do
    it 'sets balance correctly' do
      expect(
        full_model.balance
      ).to be_instance_of(BigDecimal)
    end
  end
end
