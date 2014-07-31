require 'spec_setup'

describe BackendClient::Transaction do
  include_examples 'api model'

  describe '.initialize' do
    it 'sets amount correctly' do
      expect(full_model.amount).to be_instance_of(BigDecimal)
    end

    it 'sets committed_at correctly' do
      expect(full_model.committed_at).to be_instance_of(DateTime)
    end
  end
end
