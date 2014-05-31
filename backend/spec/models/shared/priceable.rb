shared_examples 'priceable model' do
  it { should belong_to(:price) }
  it { should validate_presence_of(:price) }

  describe '#amount' do
    it 'delegates to #price' do
      expect(model.amount(currency)).to eq(model.price.amount(currency))
    end
  end

  describe '#discounted?' do
    it 'delegates to #price' do
      expect(model.discounted?).to eq(model.price.discounted?)
    end
  end
end
