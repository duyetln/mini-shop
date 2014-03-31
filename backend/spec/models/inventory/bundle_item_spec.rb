require 'spec_helper'
require 'spec/models/shared/item_resource'

describe BundleItem do

  let(:bundlings) { saved_model.bundlings }
  let(:bundling) { bundlings.sample }

  it_behaves_like 'item resource'

  it { should have_many(:bundlings).with_foreign_key(:bundle_id) }

  describe '#add_or_update' do
    let(:acc) { [true, false].sample }

    context 'kept' do
      it 'adds or updates the item' do
        expect(bundlings).to receive(:add_or_update).with(item, qty, acc)
        saved_model.add_or_update(item, qty, acc)
      end
    end

    context 'deleted' do
      it 'does not add or update the item' do
        saved_model.delete!
        expect(bundlings).to_not receive(:add_or_update)
        saved_model.add_or_update(item, qty, acc)
      end
    end
  end

  describe '#available?' do
    context 'items not present' do
      it 'is false' do
        expect(saved_model.items).to_not be_present
        expect(saved_model).to_not be_available
      end
    end

    context 'items present' do
      before :each do
        saved_model.add_or_update(item)
      end

      context 'items unavailable' do
        context 'deleted' do
          it 'is false' do
            saved_model.items.sample.delete!
            expect(saved_model).to_not be_available
          end
        end

        context 'inactive' do
          it 'is false' do
            saved_model.items.sample.deactivate!
            expect(saved_model).to_not be_available
          end
        end
      end

      context 'items available' do
        it 'is true' do
          expect(saved_model).to be_available
        end
      end
    end
  end

  describe '#remove' do
    context 'kept' do
      before :each do
        saved_model.add_or_update(item)
      end

      it 'removes the item' do
        expect(bundlings).to receive(:retrieve).with(item).and_yield(bundling)
        expect(bundling).to receive(:destroy)
        saved_model.remove(item)
      end
    end

    context 'deleted' do
      it 'does not remove the item' do
        saved_model.delete!
        expect(bundlings).to_not receive(:retrieve)
        saved_model.remove(item)
      end
    end
  end

end
