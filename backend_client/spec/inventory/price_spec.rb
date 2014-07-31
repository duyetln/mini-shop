require 'spec_setup'

describe BackendClient::Price do
  include_examples 'api resource'
  include_examples 'api model'
  include_examples 'default find'
  include_examples 'default create'
  include_examples 'default update'

  describe '.initialize' do
    it 'sets pricepoint correctly' do
      expect(
        full_model.pricepoint
      ).to be_instance_of(BackendClient::Pricepoint)
    end

    it 'sets discount correctly' do
      expect(
        full_model.discount
      ).to be_instance_of(BackendClient::Discount)
    end
  end
end
