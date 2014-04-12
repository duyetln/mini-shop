require 'spec_helper'
require 'spec/models/shared/fulfillment'

describe ShippingFulfillment do

  it_behaves_like 'fulfillment model'

  it { should ensure_inclusion_of(:item_type).in_array(%w{ PhysicalItem }) }

  describe '#process_fulfillment!' do
    let(:shipment) { FactoryGirl.build :shipment, order: model.order, item: model.item, qty: model.qty }

    before :each do
      expect(Shipment).to receive(:add_or_update).with(
        model.item,
        qty: model.qty,
        conds: { order_id: model.order.id }
      ).and_yield(shipment)
    end

    it 'adds or updates shipment for the same order' do
      model.send(:process_fulfillment!)
    end

    it 'changes the shipment user' do
      expect { model.send(:process_fulfillment!) }.to change { shipment.user }.to(model.order.user)
    end

    it 'changes the shipment shipping address' do
      expect { model.send(:process_fulfillment!) }.to change { shipment.shipping_address }.to(model.order.shipping_address)
    end
  end
end
