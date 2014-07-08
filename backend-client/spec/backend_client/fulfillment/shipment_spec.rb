require 'spec_setup'
require 'spec/backend_client/base'

describe BackendClient::Shipment do
  include_examples 'backend client'

  describe '.instantiate' do
    let(:model) { described_class.instantiate(parse(resource_payload)) }

    it 'sets item correctly' do
      expect(model.item).to be_an_instance_of(BackendClient.const_get(model.item.resource_type.classify))
    end

    it 'sets shipping address correctly' do
      expect(model.shipping_address).to be_an_instance_of(BackendClient::Address)
    end
  end
end
