require 'spec_setup'

describe BackendClient::Order do
  include_examples 'api model'

  describe '.initialize' do
    it 'sets item correctly' do
      expect(full_model.item).to be_instance_of(
        BackendClient.const_get(full_model.item.resource_type.classify)
      )
    end

    it 'sets amount correctly' do
      expect(
        full_model.amount
      ).to be_instance_of(BigDecimal)
    end

    it 'sets currency correctly' do
      expect(
        full_model.currency
      ).to be_instance_of(BackendClient::Currency)
    end

    it 'sets tax correctly' do
      expect(
        full_model.tax
      ).to be_instance_of(BigDecimal)
    end

    it 'sets tax_rate correctly' do
      expect(
        full_model.tax_rate
      ).to be_instance_of(BigDecimal)
    end

    it 'sets total correctly' do
      expect(
        full_model.total
      ).to be_instance_of(BigDecimal)
    end

    it 'sets refund correctly' do
      expect(
        full_model.refund
      ).to be_instance_of(BackendClient::RefundTransaction)
    end

    it 'sets statuses correctly' do
      expect(
        full_model.statuses.map(&:class).uniq
      ).to contain_exactly(BackendClient::Status)
    end
  end

  describe '#status' do
    it 'returns status' do
      expect(
        full_model.status
      ).to eq(full_model.statuses.find { |status| status.id == full_model.status_id })
    end
  end
end
