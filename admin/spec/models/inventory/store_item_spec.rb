require 'spec_setup'
require 'spec/models/service_resource'

describe StoreItem do
  include_examples 'service resource'
  include_examples 'default all'
  include_examples 'default find'
  include_examples 'default create'
  include_examples 'default update'
  include_examples 'default delete'

  describe '.instantiate' do
    let(:model) { described_class.instantiate(parse(resource_payload)) }

    it 'sets item correctly' do
      expect(model.item).to be_an_instance_of(model.item.resource_type.classify.constantize)
    end

    it 'sets price correctly' do
      expect(model.price).to be_an_instance_of(Price)
    end
  end
end
