require 'spec_setup'
require 'spec/base'

describe BackendClient::PricepointPrice do
  include_examples 'backend client'
  include_examples 'default update'

  describe '.instantiate' do
    let(:model) { described_class.instantiate(parse(resource_payload)) }

    it 'sets currency correctly' do
      expect(model.currency).to be_an_instance_of(BackendClient::Currency)
    end

    it 'sets amount correctly' do
      expect(model.amount).to be_an_instance_of(BigDecimal)
    end
  end
end
