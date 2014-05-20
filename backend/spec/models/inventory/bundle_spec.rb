require 'models/spec_setup'
require 'spec/models/shared/item_resource'

describe Bundle do

  it { should have_many(:bundleds) }

  let(:item) { FactoryGirl.build [:physical_item, :digital_item].sample }
  let(:bundleds) { model.bundleds }
  let(:bundled) { FactoryGirl.build :bundled, item: item, qty: qty }

  before :each do
    model.bundleds << bundled
  end

  it_behaves_like 'item resource'

  it { should have_many(:bundleds) }

  describe '#add_or_update' do
    let(:acc) { [true, false].sample }

    context 'kept' do
      it 'adds or updates the item' do
        expect(bundleds).to receive(:add_or_update).with(item, qty: qty, acc: acc)
        expect(model).to receive(:reload)
        model.add_or_update(item, qty, acc)
      end
    end

    context 'deleted' do
      it 'does not add or update the item' do
        model.delete!
        expect(bundleds).to_not receive(:add_or_update)
        expect(model).to_not receive(:reload)
        model.add_or_update(item, qty, acc)
      end
    end
  end

  describe '#available?' do
    context 'items not present' do
      it 'is false' do
        model.bundleds.clear
        expect(model.items).to_not be_present
        expect(model).to_not be_available
      end
    end

    context 'items present' do
      context 'items unavailable' do
        context 'deleted' do
          it 'is false' do
            model.items.sample.delete!
            expect(model).to_not be_available
          end
        end

        context 'inactive' do
          it 'is false' do
            model.items.sample.deactivate!
            expect(model).to_not be_available
          end
        end
      end

      context 'items available' do
        it 'is true' do
          expect(model).to be_available
        end
      end
    end
  end

  describe '#remove' do
    context 'kept' do
      it 'removes the item' do
        expect(bundleds).to receive(:retrieve).with(item).and_yield(bundled)
        expect(bundled).to receive(:destroy)
        expect(model).to receive(:reload)
        model.remove(item)
      end
    end

    context 'deleted' do
      it 'does not remove the item' do
        model.delete!
        expect(bundleds).to_not receive(:retrieve)
        expect(model).to_not receive(:reload)
        model.remove(item)
      end
    end
  end

  describe '#fulfill!' do
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

    it 'calls #prepare! on each item' do
      expect(item).to receive(:fulfill!).with(order, order.qty * bundled.qty)
      model.fulfill!(order, order.qty)
    end
  end

  describe '#reverse!' do
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

    it 'calls #reverse! on each item' do
      expect(item).to receive(:reverse!).with(order)
      model.reverse!(order)
    end
  end
end
