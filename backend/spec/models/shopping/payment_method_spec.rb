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

  let(:payment) { FactoryGirl.create(:payment, payment_method: saved_model) }

  describe '#pending_balance' do

    context 'no payments' do
      it 'equals balance' do
        expect(saved_model.pending_balance).to eq(saved_model.balance)
      end
    end

    context 'pending payments' do
      it 'equals balance minus total pending payment amount' do
        pending_balance = saved_model.balance - Currency.exchange(payment.amount, payment.currency, saved_model.currency)
        expect(saved_model.pending_balance.to_s).to eq(pending_balance.to_s)
      end
    end

    context 'committed payments' do
      it 'equals balance' do
        payment.commit!
        expect(saved_model.pending_balance).to eq(saved_model.balance)
      end
    end
  end

end
