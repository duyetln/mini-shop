require 'spec_setup'

describe BackendClient::Bundled do
  include_examples 'api model'

  describe '.initialize' do
    it 'sets item correctly' do
      expect(full_model.item).to be_instance_of(
        BackendClient.const_get(full_model.item.resource_type.classify)
      )
    end
  end
end
