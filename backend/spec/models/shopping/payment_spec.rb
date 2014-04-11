require 'spec_helper'
require 'spec/models/shared/committable'

describe Payment do

  it_behaves_like 'committable model'

  it { should belong_to(:payment_method) }
  it { should belong_to(:billing_address).class_name('Address') }
  it { should belong_to(:user) }
  it { should belong_to(:currency) }

  it { should validate_numericality_of(:amount).is_greater_than(0) }

  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:payment_method) }
  it { should validate_presence_of(:billing_address) }
  it { should validate_presence_of(:currency) }
  it { should validate_presence_of(:amount) }

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

  describe '#commit!' do
    it 'subtracts payment amount from payment method' do
      payment_method = model.payment_method
      amount = Currency.exchange(model.amount, model.currency, payment_method.currency)
      expect { model.commit! }.to change { model.payment_method.balance }.by(-amount)
    end
  end

end
