require 'spec_helper'
require 'spec/models/shared/fulfillment'

describe OnlineFulfillment do

  it_behaves_like 'fulfillment model'

  it { should ensure_inclusion_of(:item_type).in_array(%w{ DigitalItem }) }

  describe '#process_fulfillment!' do
    let(:ownership) { FactoryGirl.build :ownership, order: model.order, item: model.item }

    before :each do
      expect(Ownership).to receive(:add_or_update).with(
        model.item,
        conds: { order_id: model.order.id }
      ).and_yield(ownership)
    end

    it 'adds or updates ownership for the same order' do
      model.send(:process_fulfillment!)
    end

    it 'changes the ownership user' do
      expect { model.send(:process_fulfillment!) }.to change { ownership.user }.to(model.order.user)
    end
  end
end
