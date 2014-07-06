require 'spec_setup'
require 'spec/models/service_resource'

describe PricepointPrice do
  include_examples 'service resource'
  include_examples 'default update'

  describe '.instantiate' do
    let(:model) { described_class.instantiate(parse(resource_payload)) }

    it 'sets currency correctly' do
      expect(model.currency).to be_an_instance_of(Currency)
    end

    it 'sets amount correctly' do
      expect(model.amount).to be_an_instance_of(BigDecimal)
    end
  end
end
