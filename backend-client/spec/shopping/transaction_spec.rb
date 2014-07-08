require 'spec_setup'
require 'spec/base'

describe BackendClient::Transaction do
  include_examples 'backend client'

  describe '.instantiate' do
    let(:model) { described_class.instantiate(parse(resource_payload)) }

    it 'sets amount correctly' do
      expect(model.amount).to be_an_instance_of(BigDecimal)
    end

    it 'sets committed_at correctly' do
      expect(model.committed_at).to be_an_instance_of(DateTime)
    end
  end
end
