require 'spec_helper'

describe Price do

  it { should belong_to(:pricepoint) }
  it { should belong_to(:discount) }

  it { should validate_presence_of(:pricepoint) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

  describe '#discounted?' do

    context 'discount present' do

      let(:model_args) { [ :price, :discounted ] }

      it 'delegates to Discount#discounted?' do

        expect(saved_model.discounted?).to eq(saved_model.discount.discounted?)
      end
    end

    context 'discount not present' do

      it 'is not discounted' do

        expect(saved_model.discounted?).to be_false
      end
    end
  end

  describe '#amount' do

    let(:currency) { saved_model.pricepoint.currencies.sample }

    context 'discount present' do

      let(:model_args) { [ :price, :discounted ] }

      it 'returns correct amount' do

        expect(saved_model.amount(currency)).to eq(saved_model.pricepoint.amount(currency) * ( 1 - saved_model.discount.current_rate) )
      end
    end

    context 'discount not present' do

      it 'returns correct amount' do

        expect(saved_model.amount(currency)).to eq(saved_model.pricepoint.amount(currency))
        expect(new_model.amount(currency)).to eq(new_model.pricepoint.amount(currency))
      end
    end
  end

end