require 'models/spec_setup'
require 'spec/models/shared/item_resource'

describe DigitalItem do

  it_behaves_like 'item resource'

  describe '#prepare!' do
    let :order do
      FactoryGirl.build(
        :order,
        item: FactoryGirl.build(
          :storefront_item,
          item: model
        ),
        qty: qty
      )
    end
    let(:fulfillment) { FactoryGirl.build :online_fulfillment, order: order, item: model, qty: order.qty }

    it 'creates or updates OnlineFulfillment records' do
      expect(OnlineFulfillment).to receive(:new).with(item: model, qty: order.qty).and_return(fulfillment)
      expect(order.fulfillments).to receive(:<<).with(fulfillment)
      model.prepare!(order, order.qty)
    end
  end
end
