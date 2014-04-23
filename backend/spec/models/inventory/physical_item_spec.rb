require 'models/spec_setup'
require 'spec/models/shared/item_resource'
require 'spec/models/shared/quantifiable'

describe PhysicalItem do

  it_behaves_like 'item resource'
  it_behaves_like 'quantifiable model'

  it { should allow_mass_assignment_of(:qty) }
  it { should validate_presence_of(:qty) }

  it { should validate_numericality_of(:qty).is_greater_than_or_equal_to(0) }

  describe '#available?' do
    context 'zero qty' do
      it 'is false' do
        model.qty = 0
        expect(model).to_not be_available
      end
    end
  end

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

    context 'enough quantity' do
      let(:model_args) { [:physical_item, qty: qty] }
      let(:fulfillment) { FactoryGirl.build :shipping_fulfillment, order: order, item: model, qty: order.qty }

      it 'creates or updates ShippingFulfillment records' do
        expect(ShippingFulfillment).to receive(:new).with(item: model, qty: order.qty).and_return(fulfillment)
        expect(order.fulfillments).to receive(:<<).with(fulfillment)
        expect { model.prepare!(order, order.qty) }.to change { model.qty }.by(-order.qty)
      end
    end

    context 'not enough quantity' do
      let(:model_args) { [:physical_item, qty: 0] }

      it 'creates or updates ShippingFulfillment records' do
        expect(ShippingFulfillment).to_not receive(:new)
        expect(order.fulfillments).to_not receive(:<<)
        expect { model.prepare!(order, order.qty) }.to_not change { model.qty }
      end
    end
  end
end
