require 'models/spec_setup'
require 'spec/models/shared/item_resource'

describe DigitalItem do

  it_behaves_like 'item resource'

  let :order do
    FactoryGirl.build(
      :order,
      item: FactoryGirl.build(
        :store_item,
        item: model
      ),
      qty: qty
    )
  end

  describe '#fulfill!' do
    it 'creates or updates OnlineFulfillment records' do
      expect(OnlineFulfillment).to receive(:create!).with(item: model, order: order, qty: order.qty)
      model.fulfill!(order, order.qty)
    end
  end

  describe '#reverse!' do
    it 'does nothing' do
      model.reverse!(order)
    end
  end
end
