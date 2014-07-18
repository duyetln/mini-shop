require 'spec_setup'
require 'spec/base'

describe BackendClient::Bundled do
  include_examples 'backend client'

  describe '.instantiate' do
    let(:model) { instantiated_model }

    it 'sets item correctly' do
      expect(model.item).to be_instance_of(
        BackendClient.const_get(model.item.resource_type.classify)
      )
    end
  end
end
