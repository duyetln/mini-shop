require 'models/spec_setup'

shared_examples 'correct currency converter' do

  it 'correctly converts provided amount' do
    expected_amount = (
      BigDecimal.new(amount.to_s) *
      Application.config.currency_rates[:USD][dest_curr.code.to_sym] /
      Application.config.currency_rates[:USD][src_curr.code.to_sym]
    ).ceil(4)

    expect(described_class.exchange(amount, src_curr, dest_curr)).to eq(expected_amount)
  end

  it 'returns BigDecimal value' do
    expect(described_class.exchange(amount, src_curr, dest_curr)).to be_a(BigDecimal)
  end
end

describe Currency do

  let(:model_args) { [:usd] }

  describe 'factory model' do
    it('is valid') { expect(model.valid?).to be_true }
    it('saves successfully') { expect(model.save).to be_true }
  end

  it { should validate_uniqueness_of(:code) }
  it { should ensure_length_of(:code).is_equal_to(3) }
  it { should validate_presence_of(:code) }

  it 'upcases code after saving' do
    expect(model.code).to match(/\A[A-Z]+\Z/)
  end

  describe '.exchange' do
    let(:eur) { FactoryGirl.build :eur }
    let(:gbp) { FactoryGirl.build :gbp }

    context 'different currencies' do
      let(:src_curr) { eur }
      let(:dest_curr) { gbp }

      it_behaves_like 'correct currency converter'
    end

    context 'same currency' do
      let(:src_curr) { eur }
      let(:dest_curr) { src_curr }

      it_behaves_like 'correct currency converter'
    end
  end
end
