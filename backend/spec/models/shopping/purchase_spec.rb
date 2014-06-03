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

  it { should have_many(:orders) }
  it { should have_many(:refunds).through(:orders) }
  it { should belong_to(:payment_method) }
  it { should belong_to(:billing_address).class_name('Address') }
  it { should belong_to(:shipping_address).class_name('Address') }
  it { should belong_to(:payment).class_name('Transaction') }
  it { should belong_to(:user) }

  it { should validate_presence_of(:user) }

  context 'pending' do
    let(:subject) { model }

    it { should be_pending }
    it { should_not validate_presence_of(:payment_method) }
    it { should_not validate_presence_of(:billing_address) }
    it { should_not validate_presence_of(:shipping_address) }
    it { should validate_uniqueness_of(:committed).scoped_to(:user_id) }
  end

  context 'committed' do
    let :subject do
      model.commit!
      model
    end

    it { should be_committed }
    it { should validate_presence_of(:payment_method) }
    it { should validate_presence_of(:billing_address) }
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

  describe '#add_or_update' do
    let(:currency) { FactoryGirl.build :eur }

    context 'pending' do
      before :each do
        expect(orders).to receive(:add_or_update).with(
          item,
          qty: qty,
          acc: false
        ).and_yield(order)
        expect(model).to receive(:reload)
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

    context 'committed' do
      it 'does not add or update item' do
        model.commit!
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
        expect(model).to receive(:reload)
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

  describe '#make_payment!' do
    before :each do
      model.save!
      model.commit!
      model.stub(:paid?).and_return(false)
      model.payment_method.stub(:enough?).and_return(true)
      model.stub(:total).and_return(amount)
    end

    context 'pending' do
      before :each do
        model.stub(:committed?).and_return(false)
      end

      it 'does not do anything' do
        expect { model.send(:make_payment!) }.to_not change { model.payment }
      end
    end

    context 'paid' do
      before :each do
        model.stub(:paid?).and_return(true)
      end

      it 'does not do anything' do
        expect { model.send(:make_payment!) }.to_not change { model.payment }
      end
    end

    context 'not enought balance' do
      before :each do
        model.payment_method.stub(:enough?).and_return(false)
      end

      it 'does not do anything' do
        expect { model.send(:make_payment!) }.to_not change { model.payment }
      end
    end

    context 'zero total' do
      before :each do
        model.stub(:total).and_return(0)
      end

      it 'does not do anything' do
        expect { model.send(:make_payment!) }.to_not change { model.payment }
      end
    end

    it 'creates new payment' do
      expect { model.send(:make_payment!) }.to change { model.payment }
      expect(model.payment).to be_present
    end

    it 'sets correct information' do
      model.send(:make_payment!)
      expect(model.payment.user).to eq(model.user)
      expect(model.payment.amount).to eq(model.total)
      expect(model.payment.currency).to eq(model.payment_method_currency)
      expect(model.payment.payment_method).to eq(model.payment_method)
      expect(model.payment.billing_address).to eq(model.billing_address)
    end

    it 'does not create a new payment' do
      model.unstub(:paid?)
      model.payment_method.unstub(:enough?)
      model.unstub(:total)

      model.send(:make_payment!)
      expect(model.payment).to eq(model.send(:make_payment!))
    end
  end

  describe '#transactions' do
    it 'returns all related transactions' do
      expect(model.transactions).to eq([model.orders.map(&:refund), model.payment].flatten.compact)
    end
  end

  describe '#paid?' do
    it 'checks the presence of #payment' do
      expect(model.paid?).to eq(model.payment.present?)
    end
  end

  describe '#fulfillable?' do
    it 'equals #committed?' do
      expect(model.fulfillable?).to eq(model.committed?)
    end
  end

  describe '#reversible?' do
    it 'equals #committed?' do
      expect(model.fulfillable?).to eq(model.committed?)
    end
  end

  describe 'fulfillment methods' do
    let(:transaction) do
      FactoryGirl.build :transaction,
                        user: model.user,
                        amount: model.total,
                        currency: model.payment_method_currency,
                        payment_method: model.payment_method,
                        billing_address: model.billing_address
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
          expect(model).to receive(:make_payment!)
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
