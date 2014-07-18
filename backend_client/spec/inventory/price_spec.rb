require 'spec_setup'
require 'spec/base'

describe BackendClient::Price do
  include_examples 'backend client'
  include_examples 'default find'
  include_examples 'default create'
  include_examples 'default update'

  describe '.instantiate' do
    let(:model) { instantiated_model }

    it 'sets pricepoint correctly' do
      expect(
        model.pricepoint
      ).to be_instance_of(BackendClient::Pricepoint)
    end

    it 'sets discount correctly' do
      expect(
        model.discount
      ).to be_instance_of(BackendClient::Discount)
    end
  end
end
