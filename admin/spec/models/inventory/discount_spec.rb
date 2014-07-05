require 'spec_setup'
require 'spec/models/service_resource'

describe Discount do
  include_examples 'service resource'
  include_examples 'default all'
  include_examples 'default create'
  include_examples 'default update'

  describe '.instantiate' do
    let(:model) { described_class.instantiate(parse(resource_payload)) }

    it 'sets rate correctly' do
      expect(model.rate).to be_an_instance_of(BigDecimal)
    end

    it 'sets start_at correctly' do
      expect(model.start_at).to be_an_instance_of(DateTime)
    end

    it 'sets end_at correctly' do
      expect(model.end_at).to be_an_instance_of(DateTime)
    end
  end
end
