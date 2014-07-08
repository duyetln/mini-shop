require 'spec_setup'
require 'spec/base'

describe BackendClient::Discount do
  include_examples 'backend client'
  include_examples 'default all'
  include_examples 'default create'
  include_examples 'default update'

  describe '.instantiate' do
    let(:model) { instantiated_model }

    it 'sets rate correctly' do
      expect(
        model.rate
      ).to be_instance_of(BigDecimal)
    end

    it 'sets start_at correctly' do
      expect(
        model.start_at
      ).to be_instance_of(DateTime)
    end

    it 'sets end_at correctly' do
      expect(
        model.end_at
      ).to be_instance_of(DateTime)
    end
  end
end
