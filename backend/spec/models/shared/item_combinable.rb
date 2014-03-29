require 'spec/models/shared/itemable'
require 'spec/models/shared/quantifiable'

shared_examples 'item combinable model' do

  it_behaves_like 'itemable model'
  it_behaves_like 'quantifiable model'

  context 'class' do
    let(:subject) { described_class }
    it { should respond_to(:add_or_update).with(5).argument }
    it { should respond_to(:retrieve).with(1).argument }
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

  describe '.retrieve' do

    context 'providing the item' do
      it 'returns the model' do
        expect(described_class.retrieve(item)).to eq(saved_model)
      end
    end

    context 'providing the model' do
      it 'returns the model' do
        expect(described_class.retrieve(saved_model)).to eq(saved_model)
      end
    end

    context 'providing the model id' do
      it 'returns the model' do
        expect(described_class.retrieve(saved_model.id)).to eq(saved_model)
      end
    end
  end
end
