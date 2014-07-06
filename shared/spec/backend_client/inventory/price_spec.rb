require 'spec_setup'
require 'spec/backend_client/base'

describe BackendClient::Price do
  include_examples 'backend client'
  include_examples 'default find'
  include_examples 'default create'
  include_examples 'default update'

  describe '.instantiate' do
    let(:model) { described_class.instantiate(parse(resource_payload)) }

    it 'sets pricepoint correctly' do
      expect(model.pricepoint).to be_an_instance_of(BackendClient::Pricepoint)
    end

    it 'sets discount correctly' do
      expect(model.discount).to be_an_instance_of(BackendClient::Discount)
    end
  end
end
