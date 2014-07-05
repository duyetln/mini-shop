require 'spec_setup'
require 'spec/models/service_resource'

describe PaymentMethod do
  include_examples 'service resource'
  include_examples 'default update'

  describe '.instantiate' do
    let(:model) { described_class.instantiate(parse(resource_payload)) }

    it 'sets balance correctly' do
      expect(model.balance).to be_an_instance_of(BigDecimal)
    end
  end
end
