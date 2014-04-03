require 'spec_helper'
require 'spec/models/shared/item_resource'

describe BundleItem do

  let(:bundlings) { model.bundlings }
  let(:bundling) { bundlings.sample }
  let(:model_args) { [:bundle_item, :bundlings] }

  it_behaves_like 'item resource'

  it { should have_many(:bundlings).with_foreign_key(:bundle_id) }

  describe '#add_or_update' do
    let(:acc) { [true, false].sample }

    context 'kept' do
      it 'adds or updates the item' do
        expect(bundlings).to receive(:add_or_update).with(item, qty: qty, acc: acc)
        model.add_or_update(item, qty, acc)
      end
    end

    context 'deleted' do
      it 'does not add or update the item' do
        model.delete!
        expect(bundlings).to_not receive(:add_or_update)
        model.add_or_update(item, qty, acc)
      end
    end
  end

  describe '#available?' do
    context 'items not present' do
      it 'is false' do
        model.bundlings.clear
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
        expect(bundlings).to receive(:retrieve).with(item).and_yield(bundling)
        expect(bundling).to receive(:destroy)
        model.remove(item)
      end
    end

    context 'deleted' do
      it 'does not remove the item' do
        model.delete!
        expect(bundlings).to_not receive(:retrieve)
        model.remove(item)
      end
    end
  end

end
