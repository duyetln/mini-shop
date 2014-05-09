require 'models/spec_setup'

describe Price do

  it { should belong_to(:pricepoint) }
  it { should belong_to(:discount) }

  it { should validate_presence_of(:pricepoint) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:pricepoint_id) }
  it { should allow_mass_assignment_of(:discount_id) }

  describe '#discounted?' do
    context 'discount present' do
      let(:model_args) { [:price, :discounted] }

      it 'delegates to Discount#discounted?' do
        expect(model.discounted?).to eq(model.discount.discounted?)
      end
    end

    context 'discount not present' do
      it 'is not discounted' do
        expect(model.discounted?).to be_false
      end
    end
  end

  describe '#amount' do
    let(:currency) { model.pricepoint.pricepoint_prices.sample.currency }

    context 'discount present' do
      let(:model_args) { [:price, :discounted] }

      it 'returns correct amount' do
        expect(model.amount(currency)).to eq(model.pricepoint.amount(currency) * (1 - model.discount.current_rate))
      end
    end

    context 'discount not present' do
      it 'returns correct amount' do
        expect(model.amount(currency)).to eq(model.pricepoint.amount(currency))
      end
    end
  end
end
