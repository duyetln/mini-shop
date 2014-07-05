require 'spec_setup'
require 'spec/models/service_resource'

describe Price do
  include_examples 'service resource'
  include_examples 'default find'
  include_examples 'default create'
  include_examples 'default update'

  describe '.instantiate' do
    let(:model) { described_class.instantiate(parse(resource_payload)) }

    it 'sets pricepoint correctly' do
      expect(model.pricepoint).to be_an_instance_of(Pricepoint)
    end

    it 'sets discount correctly' do
      expect(model.discount).to be_an_instance_of(Discount)
    end
  end
end
