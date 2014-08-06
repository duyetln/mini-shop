require 'spec_setup'

describe BackendClient::Discount do
  include_examples 'api resource'
  include_examples 'api model'
  include_examples 'default all'
  include_examples 'default find'
  include_examples 'default create'
  include_examples 'default update'

  describe '.initialize' do
    it 'sets rate correctly' do
      expect(
        full_model.rate
      ).to be_instance_of(BigDecimal)
    end

    it 'sets start_at correctly' do
      expect(
        full_model.start_at
      ).to be_instance_of(DateTime)
    end

    it 'sets end_at correctly' do
      expect(
        full_model.end_at
      ).to be_instance_of(DateTime)
    end

    it 'sets current_rate correctly' do
      expect(
        full_model.current_rate
      ).to be_instance_of(BigDecimal)
    end
  end
end
