require 'spec_helper'

describe PaymentMethod do

  it { should allow_mass_assignment_of(:user_id) }
  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:currency_id) }
  it { should allow_mass_assignment_of(:balance) }

  it { should have_readonly_attribute(:user_id) }
  it { should have_readonly_attribute(:name) }
  it { should have_readonly_attribute(:currency_id) }

  it { should belong_to(:user) }
  it { should belong_to(:currency) }
  it { should have_many(:payments) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:balance) }
  it { should validate_presence_of(:currency) }
  it { should validate_presence_of(:user) }

  it { should validate_numericality_of(:balance).is_greater_than_or_equal_to(0) }

  let(:payment) { FactoryGirl.create(:payment, payment_method: model) }

  describe '#pending_balance' do
    context 'no payments' do
      it 'equals balance' do
        expect(model.pending_balance).to eq(model.balance)
      end
    end

    context 'pending payments' do
      it 'equals balance minus total pending payment amount' do
        pending_balance = model.balance - Currency.exchange(payment.amount, payment.currency, model.currency)
        expect(model.pending_balance).to eq(pending_balance)
      end
    end

    context 'committed payments' do
      it 'equals balance' do
        payment.commit!
        expect(model.pending_balance).to eq(model.balance)
      end
    end
  end

  describe '#enough?' do
    let(:amount) { rand(1..10) }

    it 'checks against #pending_balance amount' do
      enough = (model.pending_balance >= amount)
      expect(model.enough?(amount)).to eq(enough)
    end
  end

end
