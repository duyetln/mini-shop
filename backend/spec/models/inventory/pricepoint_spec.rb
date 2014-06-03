require 'models/spec_setup'

describe Pricepoint do
  let(:model_args) { [:pricepoint, :pricepoint_prices] }

  it { should have_many(:pricepoint_prices) }
  it { should have_many(:currencies).through(:pricepoint_prices) }

  it { should validate_uniqueness_of(:name) }
  it { should validate_presence_of(:name) }

  it { should allow_mass_assignment_of(:name) }

  describe '#amount' do
    context 'currency found' do
      it 'returns correct amount' do
        pricepoint_price = model.pricepoint_prices.sample
        expect(model.amount(pricepoint_price.currency)).to eq(pricepoint_price.amount)
      end
    end

    context 'currency not found' do
      it 'returns nil' do
        expect(model.amount(Currency.new)).to eq(nil)
      end
    end
  end
end
