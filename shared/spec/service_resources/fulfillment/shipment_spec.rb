require 'spec_setup'
require 'spec/models/service_resource'

describe Shipment do
  include_examples 'service resource'

  describe '.instantiate' do
    let(:model) { described_class.instantiate(parse(resource_payload)) }

    it 'sets item correctly' do
      expect(model.item).to be_an_instance_of(model.item.resource_type.classify.constantize)
    end

    it 'sets shipping address correctly' do
      expect(model.shipping_address).to be_an_instance_of(Address)
    end
  end
end
