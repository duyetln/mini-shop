require 'spec_setup'
require 'spec/models/service_resource'

describe Bundled do
  include_examples 'service resource'

  describe '.instantiate' do
    let(:model) { described_class.instantiate(parse(resource_payload)) }

    it 'sets bundleds correctly' do
      expect(model.item).to be_an_instance_of(model.item.resource_type.classify.constantize)
    end
  end
end
