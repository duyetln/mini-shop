require 'spec_setup'

describe BackendClient::Shipment do
  include_examples 'api model'

  describe '.instantiate' do
    it 'sets item correctly' do
      expect(full_model.item).to be_instance_of(
        BackendClient.const_get(full_model.item.resource_type.classify)
      )
    end

    it 'sets shipping_address correctly' do
      expect(
        full_model.shipping_address
      ).to be_instance_of(BackendClient::Address)
    end
  end
end
