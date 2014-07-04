require 'spec_setup'
require 'spec/models/service_resource'

describe User do
  include_examples 'service resource'
  include_examples 'default all'
  include_examples 'default find'
  include_examples 'default create'
  include_examples 'default update'

  describe '.instantiate' do
    let(:model) { described_class.instantiate(parse(resource_payload)) }

    it 'sets addresses correctly' do
      expect(model.addresses).to contain_exactly(
        an_instance_of(Address),
        an_instance_of(Address)
      )
    end

    it 'sets payment methods correctly' do
      expect(model.payment_methods).to contain_exactly(an_instance_of(PaymentMethod))
    end
  end
end
