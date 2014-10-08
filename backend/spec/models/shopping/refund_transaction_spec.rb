require 'models/spec_setup'
require 'spec/models/shared/transaction'

describe RefundTransaction do
  it_behaves_like 'transaction model'
end

describe RefundTransaction do
  describe '#commit!' do
    let(:payment_method) { model.payment_method }
    let(:amount) { Currency.exchange(model.amount, model.currency, payment_method.currency) }

    it 'deposits amount to payment method' do
      expect { model.commit! }.to change { payment_method.balance }.by(amount.abs)
      expect(model).to be_committed
    end

    it 'does not over deposit' do
      expect { model.commit! }.to change { payment_method.balance }.by(amount.abs)
      rand(1..5).times do
        expect { model.commit! }.to_not change { payment_method.balance }
      end
    end
  end
end
