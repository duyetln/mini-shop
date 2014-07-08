require 'spec_setup'
require 'spec/base'

describe BackendClient::StoreItem do
  include_examples 'backend client'
  include_examples 'default all'
  include_examples 'default find'
  include_examples 'default create'
  include_examples 'default update'
  include_examples 'default delete'

  describe '.instantiate' do
    let(:model) { instantiated_model }

    it 'sets item correctly' do
      expect(model.item).to be_instance_of(
        BackendClient.const_get(model.item.resource_type.classify)
      )
    end

    it 'sets price correctly' do
      expect(
        model.price
      ).to be_instance_of(BackendClient::Price)
    end
  end
end
