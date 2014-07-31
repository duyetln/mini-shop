require 'spec_setup'

describe BackendClient::StoreItem do
  include_examples 'api resource'
  include_examples 'api model'
  include_examples 'default all'
  include_examples 'default find'
  include_examples 'default create'
  include_examples 'default update'
  include_examples 'default delete'

  describe '.initialize' do
    it 'sets item correctly' do
      expect(full_model.item).to be_instance_of(
        BackendClient.const_get(full_model.item.resource_type.classify)
      )
    end

    it 'sets price correctly' do
      expect(
        full_model.price
      ).to be_instance_of(BackendClient::Price)
    end
  end
end
