require 'spec_setup'
require 'spec/base'

describe BackendClient::Ownership do
  include_examples 'backend client'

  describe '.instantiate' do
    let(:model) { described_class.instantiate(parse(resource_payload)) }

    it 'sets item correctly' do
      expect(model.item).to be_an_instance_of(BackendClient.const_get(model.item.resource_type.classify))
    end
  end
end
