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

  before :each do
    model.save!
  end

  let(:item) { model.item }
  let(:qty) { model.qty + 1 }

  describe '.add_or_update' do
    context 'accumulation' do
      it 'increments the qty' do
        expect { described_class.add_or_update(item, qty: qty) }.to change{
          described_class.where(
            item_type: item.class,
            item_id: item.id
          ).first_or_initialize.qty
        }.by(qty)
      end
    end

    context 'override' do
      it 'updates the qty' do
        expect { described_class.add_or_update(item, qty: qty, acc: false) }.to change{
          described_class.where(
            item_type: item.class,
            item_id: item.id
          ).first_or_initialize.qty
        }.to(qty)
      end
    end
  end

  describe '.retrieve' do
    context 'providing the item' do
      it 'returns the model' do
        expect(described_class.retrieve(item)).to eq(model)
      end
    end

    context 'providing the model' do
      it 'returns the model' do
        expect(described_class.retrieve(model)).to eq(model)
      end
    end

    context 'providing the model id' do
      it 'returns the model' do
        expect(described_class.retrieve(model.id)).to eq(model)
      end
    end
  end
end
