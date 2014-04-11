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
  it { should have_many(:transactions) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:balance) }
  it { should validate_presence_of(:currency) }
  it { should validate_presence_of(:user) }

  it { should validate_numericality_of(:balance).is_greater_than_or_equal_to(0) }

  let(:transaction) { FactoryGirl.create(:transaction, payment_method: model) }

  describe '#pending_balance' do
    context 'no transactions' do
      it 'equals balance' do
        expect(model.pending_balance).to eq(model.balance)
      end
    end

    context 'pending transactions' do
      it 'equals balance minus total pending transaction amount' do
        pending_balance = model.balance - Currency.exchange(transaction.amount, transaction.currency, model.currency)
        expect(model.pending_balance).to eq(pending_balance)
      end
    end

    context 'committed transactions' do
      it 'equals balance' do
        transaction.commit!
        expect(model.pending_balance).to eq(model.balance)
      end
    end
  end

  describe '#enough?' do
    it 'checks against #pending_balance amount' do
      enough = (model.pending_balance >= amount)
      expect(model.enough?(amount)).to eq(enough)
    end
  end

  describe '#deposit!' do
    before :each do
      expect(model).to receive(:save!)
    end

    let(:converted_amount) { Currency.exchange(amount, currency, model.currency) }

    context 'positive amount' do
      it 'adds to the balance' do
        expect { model.deposit!(amount, currency) }.to change { model.balance }.by(converted_amount)
      end
    end

    context 'negative amount' do
      it 'adds to the balance' do
        expect { model.deposit!(-amount, currency) }.to change { model.balance }.by(converted_amount)
      end
    end
  end

  describe '#withdraw!' do
    before :each do
      expect(model).to receive(:save!)
    end

    let(:converted_amount) { Currency.exchange(amount, currency, model.currency) }

    context 'positive amount' do
      it 'subtracts from the balance' do
        expect { model.withdraw!(amount, currency) }.to change { model.balance }.by(-converted_amount)
      end
    end

    context 'negative amount' do
      it 'subtracts from the balance' do
        expect { model.withdraw!(-amount, currency) }.to change { model.balance }.by(-converted_amount)
      end
    end
  end
end
