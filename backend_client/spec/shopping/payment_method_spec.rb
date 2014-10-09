require 'spec_setup'

describe BackendClient::PaymentMethod do
  include_examples 'api resource'
  include_examples 'api model'
  include_examples 'default update'

  describe '.initialize' do
    it 'sets balance correctly' do
      expect(
        full_model.balance
      ).to be_instance_of(BigDecimal)
    end

    it 'sets pending balance correctly' do
      expect(
        full_model.pending_balance
      ).to be_instance_of(BigDecimal)
    end

    it 'sets currency correctly' do
      expect(
        full_model.currency
      ).to be_instance_of(BackendClient::Currency)
    end

    it 'sets billing address correctly' do
      expect(
        full_model.billing_address
      ).to be_instance_of(BackendClient::Address)
    end
  end
end
