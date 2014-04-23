require 'models/spec_setup'
require 'spec/models/shared/fulfillment'

describe OnlineFulfillment do

  it_behaves_like 'fulfillment model'

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
end
