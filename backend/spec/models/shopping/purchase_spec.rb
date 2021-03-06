require 'models/spec_setup'
require 'spec/models/shared/committable'

describe Purchase do
  it_behaves_like 'committable model'
  include_examples 'default #committable?'
end

describe Purchase do
  let(:orders) { model.orders }
  let(:order) { orders.sample }
  let(:model_args) { [:purchase, :orders] }
  let(:item) { FactoryGirl.build :store_item }

  it { should have_readonly_attribute(:user_id) }

  it { should have_many(:orders).inverse_of(:purchase) }
  it { should have_many(:refund_transactions).through(:orders) }
  it { should belong_to(:payment_method) }
  it { should belong_to(:shipping_address).class_name('Address') }
  it { should belong_to(:payment_transaction).class_name('PaymentTransaction') }
  it { should belong_to(:user).inverse_of(:purchases) }

  it { should validate_presence_of(:user) }

  context 'pending' do
    let(:subject) { model }

    it { should be_pending }
    it { should_not validate_presence_of(:payment_method) }
    it { should_not validate_presence_of(:shipping_address) }
  end

  context 'committed' do
    let :subject do
      model.commit!
      model
    end

    it { should be_committed }
    it { should validate_presence_of(:payment_method) }
    it { should validate_presence_of(:shipping_address) }
  end

  describe '#normalize!' do
    it 'sets the order currency to payment method currency' do
      expect(order).to receive(:currency=).with(model.payment_method.currency)
      expect(order).to receive(:save!)
      model.normalize!
    end
  end

  describe '#commit!' do
    it 'calls #normalize!' do
      expect(model).to receive(:normalize!)
      model.commit!
    end
  end

  describe '#payment_method_currency' do
    it 'delegates to #payment_method' do
      expect(model.payment_method_currency).to eq(model.payment_method.currency)
    end
  end

  describe '#currency' do
    it 'delegates to #payment_method' do
      expect(model.currency).to eq(model.payment_method.currency)
    end
  end

  describe '#add_or_update' do
    let(:currency) { FactoryGirl.build :eur }

    before :each do
      expect(model).to receive(:changeable?).and_return(changeable)
    end

    context 'changeable' do
      let(:changeable) { true }

      before :each do
        expect(orders).to receive(:add_or_update).with(
          item,
          qty: qty,
          acc: false
        ).and_yield(order)
        expect(model).to receive(:reload).at_least(:once)
      end

      it 'adds or updates order' do
        model.add_or_update(item, amount, currency, qty)
      end

      it 'updates order amount and currency' do
        expect(order).to receive(:amount=).with(amount)
        expect(order).to receive(:currency=).with(currency)
        model.add_or_update(item, amount, currency, qty)
      end
    end

    context 'not changeable' do
      let(:changeable) { false }

      it 'does not add or update item' do
        expect(orders).to_not receive(:add_or_update)
        expect(model).to_not receive(:reload)
        model.add_or_update(item, amount, currency, qty)
      end
    end
  end

  describe '#remove' do
    context 'pending' do
      before :each do
        expect(orders).to receive(:retrieve).with(item).and_yield(order)
        expect(model).to receive(:reload).at_least(:once)
      end

      it 'retrieves the item' do
        model.remove(item)
      end

      it 'removes the item' do
        expect { model.remove(item) }.to change { order.deleted? }.to(true)
      end
    end

    context 'committed' do
      it 'does not remove the item' do
        model.commit!
        expect(orders).to_not receive(:retrieve)
        expect(model).to_not receive(:reload)
        model.remove(item)
      end
    end
  end

  describe '#amount' do
    it 'sums order amount' do
      total_amount = model.orders.reduce(BigDecimal('0.0')) do |a, e|
        a + Currency.exchange(e.amount, e.currency, currency)
      end
      expect(model.amount(currency)).to eq(total_amount)
    end
  end

  describe '#tax' do
    it 'sums order tax' do
      total_tax = model.orders.reduce(BigDecimal('0.0')) do |a, e|
        a + Currency.exchange(e.tax, e.currency, currency)
      end
      expect(model.tax(currency)).to eq(total_tax)
    end
  end

  describe '#total' do
    it 'sums order total' do
      total = model.orders.reduce(BigDecimal('0.0')) do |a, e|
        a + Currency.exchange(e.total, e.currency, currency)
      end
      expect(model.total(currency)).to eq(total)
    end
  end

  describe '#paid_amount' do
    context 'not paid' do
      before :each do
        expect(model).to_not be_paid
      end

      it 'equals 0' do
        expect(model.paid_amount).to eq(0.0)
      end
    end

    context 'paid' do
      before :each do
        model.save!
        model.commit!
        model.pay!
      end

      before :each do
        expect(model).to be_paid
      end

      it 'equals payment transaction amount' do
        expect(model.paid_amount).to eq(model.payment_transaction.amount)
      end
    end
  end

  describe '#refund_amount' do
    it 'sums refund transaction amount' do
      expected_amount = model.refund_transactions.map(&:amount).reduce(BigDecimal.new('0.0'), &:+)
      expect(model.refund_amount).to eq(expected_amount)
    end
  end

  describe '#charge_amount' do
    it 'subtracts refund amount from paid amount' do
      expect(model.charge_amount).to eq(model.paid_amount - model.refund_amount)
    end
  end

  describe '#pay!' do
    before :each do
      model.save!
      model.commit!
      model.stub(:free?).and_return(false)
      model.stub(:paid?).and_return(false)
      model.stub(:total).and_return(amount)
      model.payment_method.stub(:enough?).with(amount).and_return(true)
    end

    context 'pending' do
      before :each do
        model.stub(:committed?).and_return(false)
      end

      it 'does not do anything' do
        expect { model.pay! }.to_not change { model.payment_transaction }
      end
    end

    context 'free' do
      before :each do
        model.stub(:free?).and_return(true)
      end

      it 'does nothing' do
        expect { model.pay! }.to_not change { model.payment_transaction }
      end
    end

    context 'paid' do
      before :each do
        model.stub(:paid?).and_return(true)
      end

      it 'does not do anything' do
        expect { model.pay! }.to_not change { model.payment_transaction }
      end
    end

    context 'not enought balance' do
      before :each do
        model.payment_method.stub(:enough?).with(amount).and_return(false)
      end

      it 'does not do anything' do
        expect { model.pay! }.to_not change { model.payment_transaction }
      end
    end

    it 'creates new payment' do
      expect { model.pay! }.to change { model.payment_transaction }
      expect(model.payment_transaction).to be_present
    end

    it 'sets correct information' do
      model.pay!
      expect(model.payment_transaction.class).to eq(PaymentTransaction)
      expect(model.payment_transaction.user).to eq(model.user)
      expect(model.payment_transaction.amount).to eq(model.total)
      expect(model.payment_transaction.currency).to eq(model.payment_method_currency)
      expect(model.payment_transaction.payment_method).to eq(model.payment_method)
    end

    it 'does not create a new payment' do
      model.unstub(:free?)
      model.unstub(:paid?)
      model.payment_method.unstub(:enough?)
      model.unstub(:total)

      model.pay!
      expect(model.payment_transaction).to eq(model.pay!)
    end
  end

  describe '#transactions' do
    it 'returns all related transactions' do
      expect(model.transactions).to eq([model.orders.map(&:refund_transaction), model.payment_transaction].flatten.compact)
    end
  end

  describe '#free?' do
    it 'checks the total amount' do
      expect(model.free?).to eq(model.total <= 0)
    end
  end

  describe '#paid?' do
    it 'checks the presence of #payment' do
      expect(model.paid?).to eq(model.payment_transaction.present?)
    end
  end

  describe '#changeable?' do
    it 'equals itself being pending' do
      expect(model.changeable?).to eq(model.pending?)
    end
  end

  describe '#fulfillable?' do
    it 'equals #committed?' do
      expect(model.fulfillable?).to eq(model.committed? && (model.free? || model.paid?))
    end
  end

  describe '#reversible?' do
    it 'equals #committed?' do
      expect(model.fulfillable?).to eq(model.committed?)
    end
  end

  describe 'fulfillment methods' do
    let(:transaction) do
      FactoryGirl.build :payment_transaction,
                        user: model.user,
                        amount: model.total,
                        currency: model.payment_method_currency,
                        payment_method: model.payment_method
    end

    before :each do
      model.stub(:transactions).and_return([transaction])
    end

    shared_examples 'status not ready' do
      context 'status not ready' do
        before :each do
          model.stub(status_method).and_return(false)
        end

        it 'does nothing' do
          expect(order).to_not receive(process_method)
          expect(transaction).to_not receive(:commit!)
          expect(model.send(method)).to be_nil
        end
      end
    end

    describe '#fufill!' do
      let(:method) { :fulfill! }
      let(:process_method) { :fulfill! }
      let(:status_method) { :fulfillable? }

      before :each do
        model.stub(status_method).and_return(true)
      end

      include_examples 'status not ready'

      context 'ready' do
        it 'processes, marks status, and returns' do
          expect(order).to receive(process_method)
          expect(transaction).to receive(:commit!)
          expect(model).to receive(:reload)
          model.send(method)
        end
      end
    end

    describe '#reverse!' do
      let(:method) { :reverse! }
      let(:process_method) { :reverse! }
      let(:status_method) { :reversible? }

      before :each do
        model.stub(status_method).and_return(true)
      end

      include_examples 'status not ready'

      context 'ready' do
        context 'full purchase reversal' do
          it 'processes, marks status, and returns' do
            expect(order).to receive(process_method)
            expect(transaction).to receive(:commit!)
            expect(model).to receive(:reload)
            model.send(method)
          end
        end

        context 'single order reversal' do
          it 'processes, marks status, and returns' do
            expect(orders).to receive(:retrieve).with(order).and_return(order)
            expect(order).to receive(process_method)
            expect(transaction).to receive(:commit!)
            expect(model).to receive(:reload)
            model.send(method, order)
          end
        end
      end
    end
  end
end
