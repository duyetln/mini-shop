require 'spec_setup'
require 'spec/backend_client/base'

describe BackendClient::PaymentMethod do
  include_examples 'backend client'
  include_examples 'default update'

  describe '.instantiate' do
    let(:model) { described_class.instantiate(parse(resource_payload)) }

    it 'sets balance correctly' do
      expect(model.balance).to be_an_instance_of(BigDecimal)
    end
  end
end
