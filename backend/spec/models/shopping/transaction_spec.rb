require 'models/spec_setup'
require 'spec/models/shared/committable'

describe Transaction do
  it_behaves_like 'committable model'
  include_examples 'default #committable?'
end

describe Transaction do
  it { should belong_to(:payment_method) }
  it { should belong_to(:billing_address).class_name('Address') }
  it { should belong_to(:user) }
  it { should belong_to(:currency) }

  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:payment_method) }
  it { should validate_presence_of(:billing_address) }
  it { should validate_presence_of(:currency) }
  it { should validate_presence_of(:amount) }
  it { should validate_uniqueness_of(:uuid) }

  it { should_not allow_mass_assignment_of(:uuid) }
  it { should have_readonly_attribute(:uuid) }
  it { should have_readonly_attribute(:user_id) }
  it { should have_readonly_attribute(:payment_method_id) }
  it { should have_readonly_attribute(:billing_address_id) }
  it { should have_readonly_attribute(:amount) }
  it { should have_readonly_attribute(:currency_id) }

  describe '#payment_method_currency' do
    it 'delegates to #payment_method' do
      expect(model.payment_method_currency).to eq(model.payment_method.currency)
    end
  end

  describe '#uuid' do
    context 'new payment' do
      it 'is present' do
        expect(model.uuid).to be_present
      end
    end

    context 'saved payment' do
      it 'is present' do
        model.save!
        expect(model.uuid).to be_present
      end
    end
  end

  describe '#payment?' do
    it 'compares amount with zero' do
      expect(model.payment?).to eq(model.amount >= 0)
    end
  end

  describe '#refund?' do
    it 'opposites #payment?' do
      expect(model.refund?).to eq(!model.payment?)
    end
  end

  describe '#commit!' do
    context 'payment transaction' do
      let(:model_args) { [:transaction, :payment] }

      it 'withdraws amount from payment method' do
        payment_method = model.payment_method
        amount = Currency.exchange(model.amount, model.currency, payment_method.currency)
        expect { model.commit! }.to change { payment_method.balance }.by(-amount.abs)
      end
    end

    context 'refund transaction' do
      let(:model_args) { [:transaction, :refund] }

      it 'deposits amount to payment method' do
        payment_method = model.payment_method
        amount = Currency.exchange(model.amount, model.currency, payment_method.currency)
        expect { model.commit! }.to change { payment_method.balance }.by(amount.abs)
      end
    end
  end
end
