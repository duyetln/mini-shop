require 'models/spec_setup'
require 'spec/models/shared/fulfillment'

describe ShippingFulfillment do

  it_behaves_like 'fulfillment model'

  it { should ensure_inclusion_of(:item_type).in_array(%w{ PhysicalItem }) }

  describe '#process_fulfillment!' do
    it 'creates a new shipment' do
      expect(Shipment).to receive(:create!).with(
        item: model.item,
        qty: model.qty,
        order: model.order,
        user: model.order.user,
        shipping_address: model.order.shipping_address
      )
      model.send(:process_fulfillment!)
    end
  end
end
