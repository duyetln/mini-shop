require 'models/spec_setup'
require 'spec/models/shared/fulfillment'

describe OnlineFulfillment do
  it_behaves_like 'fulfillment model'
end

describe OnlineFulfillment do
  it { should ensure_inclusion_of(:item_type).in_array(%w{ DigitalItem }) }

  describe '#process_fulfillment!' do
    it 'creates a new ownership' do
      expect(Ownership).to receive(:create!).with(
        item: model.item,
        qty: model.qty,
        order: model.order,
        user: model.order.user
      )
      model.send(:process_fulfillment!)
    end
  end

  describe '#process_reversal!' do
    let(:ownership) { FactoryGirl.build :ownership, order: model.order }

    it 'deletes related ownerships' do
      expect(Ownership).to receive(:where).with(
        item_type: model.item.class,
        item_id: model.item.id,
        order_id: model.order.id
      ).and_return([ownership])
      expect(ownership).to receive(:delete!)
      model.send(:process_reversal!)
    end
  end
end
