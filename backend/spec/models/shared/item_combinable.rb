require 'spec/models/shared/itemable'
require 'spec/models/shared/quantifiable'

shared_examples 'item combinable model' do

  it_behaves_like 'itemable model'
  it_behaves_like 'quantifiable model'

  context 'class' do
    let(:subject) { described_class }
    it { should respond_to(:add_or_update).with(5).argument }
    it { should respond_to(:get).with(1).argument }
  end

  let(:item) { saved_model.item }
  let(:quantity) { rand(1..10) }

  describe '.add_or_update' do

    context 'accumulation' do
      it 'increments the quantity' do
        expect { described_class.add_or_update(item, quantity) }.to change{
          described_class.where(
            item_type: item.class,
            item_id: item.id
          ).first_or_initialize.quantity
        }.by(quantity)
      end
    end

    context 'override' do
      it 'updates the quantity' do
        expect { described_class.add_or_update(item, quantity, false) }.to change{
          described_class.where(
            item_type: item.class,
            item_id: item.id
          ).first_or_initialize.quantity
        }.to(quantity)
      end
    end
  end

  describe '.get' do

    it 'returns the model storing the item' do
      expect(described_class.get(item)).to eq(saved_model)
    end
  end
end
