require 'spec_setup'

describe BackendClient::Ownership do
  include_examples 'api model'

  describe '.initialize' do
    it 'sets item correctly' do
      expect(full_model.item).to be_instance_of(
        BackendClient.const_get(full_model.item.resource_type.classify)
      )
    end
  end

  describe '#purchase' do
    let(:purchase) { BackendClient::Purchase.instantiate parse(purchase_payload) }

    before :each do
      bare_model.purchase_id = rand_str
    end

    it 'returns promotion' do
      expect(BackendClient::Purchase).to receive(:find).with(bare_model.purchase_id).and_return(purchase)
      expect(bare_model.purchase).to eq(purchase)
    end
  end

  describe '#order' do
    let(:purchase) { BackendClient::Purchase.instantiate parse(purchase_payload) }
    let(:order) { purchase.orders.sample }
    let(:order_id) { order.id }

    before :each do
      bare_model.order_id = order_id
      expect(bare_model).to receive(:purchase).and_return(purchase)
    end

    it 'returns order' do
      expect(bare_model.order).to eq(order)
    end
  end
end
