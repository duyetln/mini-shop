require 'spec_helper'

describe Discount do

  it { should validate_presence_of(:rate) }
  it { should validate_presence_of(:name) }

  it { should validate_numericality_of(:rate).is_greater_than_or_equal_to(0) }
  it { should validate_uniqueness_of(:name) }

  describe 'discount dates' do
    let(:model_args) { [:discount, :half] }

    context 'start date is after end date' do
      it 'is valid' do
        saved_model.start_at = 5.days.from_now
        saved_model.end_at   = 5.days.ago
        expect(saved_model).to_not be_valid
      end
    end

    context 'start date is before end date' do
      it 'is valid' do
        saved_model.start_at = 5.days.ago
        saved_model.end_at   = 5.days.from_now
        expect(saved_model).to be_valid
      end
    end
  end

  describe '#rate_at' do
    let(:model_args) { [:discount, :random, time] }

    context 'past' do
      let(:time) { :past }

      it 'returns 0 rate' do
        expect(saved_model.rate_at).to eq(0)
      end
    end

    context 'present' do
      let(:time) { :present }

      it 'returns saved rate' do
        expect(saved_model.rate_at).to eq(saved_model.rate)
      end
    end

    context 'future' do
      let(:time) { :future }

      it 'returns 0 rate' do
        expect(saved_model.rate_at).to eq(0)
      end
    end
  end

  describe '#discounted?' do
    let(:model_args) { [:discount, :random] }

    context '#rate_at is non-zero' do
      it 'is false' do
        expect(saved_model).to receive(:rate_at).and_return(rand(10) + 1)
        expect(saved_model.discounted?).to be_true
      end
    end

    context '#rate_at is zero' do
      it 'is true' do
        expect(saved_model).to receive(:rate_at).and_return(0)
        expect(saved_model.discounted?).to be_false
      end
    end
  end

  describe '#current_rate' do
    let(:model_args) { [:discount, :random] }

    it 'delegates to #rate_at' do
      expect(saved_model.current_rate).to eq(saved_model.rate_at)
    end
  end
end
