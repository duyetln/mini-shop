require 'models/spec_setup'
require 'spec/models/shared/item_resource'

describe Bundle do
  it_behaves_like 'item resource'
end

describe Bundle do
  let(:model_args) { [:bundle, :bundleds] }
  let(:bundleds) { model.bundleds }
  let(:bundled) { bundleds.sample }
  let(:item) { bundled.item }
  let(:qty) { bundled.qty }

  before :each do
    model.save!
  end

  it { should have_many(:bundleds).inverse_of(:bundle) }

  describe '#activable?' do
    it 'equals itself being inactive and all items being active' do
      expect(model.activable?).to eq(model.inactive? && model.items.all?(&:active?))
    end
  end

  describe '#changeable?' do
    it 'equals itself being inactive and kept' do
      expect(model.changeable?).to eq(model.inactive? && model.kept?)
    end
  end

  describe '#add_or_update' do
    let(:acc) { [true, false].sample }

    before :each do
      expect(model).to receive(:changeable?).and_return(changeable)
    end

    context 'changeable' do
      let(:changeable) { true }

      it 'adds or updates the item' do
        expect(bundleds).to receive(:add_or_update).with(item, qty: qty, acc: acc)
        expect(model).to receive(:reload)
        model.add_or_update(item, qty, acc)
      end
    end

    context 'not changeable' do
      let(:changeable) { false }

      it 'does not add or update the item' do
        expect(bundleds).to_not receive(:add_or_update)
        expect(model).to_not receive(:reload)
        model.add_or_update(item, qty, acc)
      end
    end
  end

  describe '#available?' do
    context 'items not present' do
      it 'is false' do
        model.bundleds.destroy_all
        expect(model).to_not be_available
      end
    end

    context 'items present' do
      before :each do
        expect(model.items).to be_present
        model.stub(:items).and_return([item])
      end

      context 'items unavailable' do
        it 'is false' do
          item.stub(:available?).and_return(false)
          expect(model).to_not be_available
        end
      end

      context 'items available' do
        it 'is true' do
          item.stub(:available?).and_return(true)
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
      expect(bundleds).to receive(:retrieve).with(item).and_return(bundled)
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
