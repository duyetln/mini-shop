require 'models/spec_setup'
require 'spec/models/shared/fulfillment'

describe ShippingFulfillment do

  it_behaves_like 'fulfillment model'

  it { should ensure_inclusion_of(:item_type).in_array(%w{ PhysicalItem }) }

  describe '#process_fulfillment!' do
    context 'enough quantity' do
      before :each do
        model.item.qty = model.qty + qty
      end

      it 'creates a new shipment' do
        expect(Shipment).to receive(:create!).with(
          item: model.item,
          qty: model.qty,
          order: model.order,
          user: model.order.user,
          shipping_address: model.order.shipping_address
        )
        expect { model.send(:process_fulfillment!) }.to change { model.item.qty }.by(-model.qty)
      end
    end

    context 'not enough quantity' do
      before :each do
        model.item.qty = 0
      end

      it 'does not thing' do
        expect(Shipment).to_not receive(:create!)
        expect { model.send(:process_fulfillment!) }.to_not change { model.item.qty }
      end
    end
  end

  describe '#process_reversal!' do
    it 'adds qty back to item' do
      expect { model.send(:process_reversal!) }.to change { model.item.qty }.by(model.qty)
    end
  end
end
