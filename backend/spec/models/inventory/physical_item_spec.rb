require 'models/spec_setup'
require 'spec/models/shared/item_resource'
require 'spec/models/shared/quantifiable'

describe PhysicalItem do
  it_behaves_like 'item resource'
  it_behaves_like 'quantifiable model'
  include_examples 'default item resource #activable?'
end

describe PhysicalItem do
  it { should allow_mass_assignment_of(:qty) }
  it { should validate_presence_of(:qty) }

  it { should validate_numericality_of(:qty).is_greater_than_or_equal_to(0) }

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
    let(:model_args) { [:physical_item, qty: qty] }

    context 'enough quantity' do
      before :each do
        model.qty = order.qty + qty
      end

      it 'creates new ShippingFulfillment record' do
        expect { model.fulfill!(order, order.qty) }.to change { ShippingFulfillment.count }.by(1)
      end

      it 'sets correct ShippmentFulfillment attributes' do
        model.fulfill!(order, order.qty)
        fulfillment = ShippingFulfillment.last
        expect(fulfillment.item).to eq(model)
        expect(fulfillment.qty).to eq(order.qty)
      end

      it 'substracts quantity' do
        expect { model.fulfill!(order, order.qty) }.to change { model.qty }.by(-order.qty)
      end
    end

    context 'not enough quantity' do
      before :each do
        model.qty = 0
      end

      it 'does nothing' do
        expect(ShippingFulfillment).to_not receive(:create!)
        expect(model).to_not receive(:save!)
        expect { model.fulfill!(order, order.qty) }.to_not change { model.qty }
      end
    end
  end

  describe '#reverse!' do
    let(:fulfillment) { FactoryGirl.build :shipping_fulfillment, order: order, item: model }

    before :each do
      fulfillment.save!
    end

    it 'adds back the quantity' do
      expect { model.reverse!(order) }.to change { model.qty }.by(fulfillment.qty)
    end
  end

  describe '#available?' do
    context 'zero qty' do
      it 'is false' do
        model.qty = 0
        expect(model).to_not be_available
      end
    end
  end
end
