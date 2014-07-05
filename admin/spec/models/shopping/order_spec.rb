require 'spec_setup'
require 'spec/models/service_resource'

describe Order do
  include_examples 'service resource'

  describe '.instantiate' do
    let(:model) { described_class.instantiate(parse(resource_payload)) }

    it 'sets item correctly' do
      expect(model.item).to be_an_instance_of(model.item.resource_type.classify.constantize)
    end

    it 'sets amount correctly' do
      expect(model.amount).to be_an_instance_of(BigDecimal)
    end

    it 'sets tax correctly' do
      expect(model.tax).to be_an_instance_of(BigDecimal)
    end

    it 'sets tax_rate correctly' do
      expect(model.tax_rate).to be_an_instance_of(BigDecimal)
    end

    it 'sets total correctly' do
      expect(model.total).to be_an_instance_of(BigDecimal)
    end

    it 'sets refund correctly' do
      expect(model.refund).to be_an_instance_of(Transaction)
    end

    it 'sets statuses correctly' do
      expect(model.statuses).to contain_exactly(
        an_instance_of(Status),
        an_instance_of(Status)
      )
    end
  end
end
