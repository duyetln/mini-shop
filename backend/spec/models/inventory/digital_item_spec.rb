require 'spec_helper'
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

    it 'creates or updates OnlineFulfillment records' do
      expect(OnlineFulfillment).to receive(:add_or_update).with(
        model,
        qty: qty,
        conds: { order_id: order.id }
      )
      model.prepare!(order, order.qty)
    end
  end
end
