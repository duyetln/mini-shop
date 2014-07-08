require 'spec_setup'
require 'spec/base'

describe BackendClient::PaymentMethod do
  include_examples 'backend client'
  include_examples 'default update'

  describe '.instantiate' do
    let(:model) { instantiated_model }

    it 'sets balance correctly' do
      expect(
        model.balance
      ).to be_instance_of(BigDecimal)
    end
  end
end
