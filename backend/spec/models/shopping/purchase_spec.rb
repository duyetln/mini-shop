require 'spec_helper'
require 'spec/models/shared/committable'

describe Purchase do

  let(:orders) { model.orders }
  let(:order) { orders.sample }
  let(:model_args) { [:purchase, :orders] }
  let(:item) { FactoryGirl.build :storefront_item }

  it_behaves_like 'committable model'

  it { should have_readonly_attribute(:user_id) }

  it { should have_many(:orders) }
  it { should belong_to(:payment_method) }
  it { should belong_to(:billing_address).class_name('Address') }
  it { should belong_to(:shipping_address).class_name('Address') }
  it { should belong_to(:user) }
  it { should have_many(:transactions) }

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

  describe '#payment_method_currency' do
    it 'delegates to #payment_method' do
      expect(model.payment_method_currency).to eq(model.payment_method.currency)
    end
  end

  describe '.pending_purchase' do
    before :each do
      user.save!
    end

    def pending_count
      described_class.where(user_id: user.id).pending.count
    end

    it 'finds or create the pending purchase' do
      change = pending_count < 1 ? 1 : 0
      expect { described_class.pending_purchase(user) }.to change { pending_count }.by(change)
      expect(described_class.pending_purchase(user)).to be_pending
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
      end

      it 'adds or updates order' do
        model.add_or_update(item, currency, qty)
      end

      it 'changes the order currency' do
        expect { model.add_or_update(item, currency, qty) }.to change { order.currency }.to(currency)
      end
    end

    context 'committed' do
      it 'does not add or update item' do
        model.commit!
        expect(orders).to_not receive(:add_or_update)
        model.add_or_update(item, currency, qty)
      end
    end
  end

  describe '#remove' do
    context 'pending' do
      before :each do
        expect(orders).to receive(:retrieve).with(item).and_yield(order)
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
        model.remove(item)
      end
    end
  end

  describe '#amount' do
    let(:model_args) { [:purchase, :orders] }

    it 'totals order amount' do
      total_amount = model.orders.reduce(BigDecimal('0.0')) do |a, e|
        a += Currency.exchange(
          e.amount,
          e.currency,
          currency
        )
      end
      expect(model.amount(currency)).to eq(total_amount)
    end
  end

  describe '#tax' do
    let(:model_args) { [:purchase, :orders] }

    it 'totals order tax' do
      total_tax = model.orders.reduce(BigDecimal('0.0')) do |a, e|
        a += Currency.exchange(
          e.tax,
          e.currency,
          currency
        )
      end
      expect(model.tax(currency)).to eq(total_tax)
    end
  end

  describe '#create_transaction!' do
    let(:transaction) { model.send(:create_transaction!, amount, currency) }

    context 'pending' do
      it 'does not do anything' do
        expect { transaction }.to_not change { model.transactions.count }
      end
    end

    context 'committed' do
      before :each do
        model.commit!
      end

      it 'creates new transaction' do
        expect { transaction }.to change { model.transactions.count }.by(1)
      end

      it 'sets correct information' do
        expect(transaction).to eq(model.transactions.last)
        expect(transaction.user).to eq(model.user)
        expect(transaction.amount).to eq(amount)
        expect(transaction.currency).to eq(currency)
        expect(transaction.payment_method).to eq(model.payment_method)
        expect(transaction.billing_address).to eq(model.billing_address)
      end
    end
  end

  describe 'fulfillment methods' do
    shared_examples 'marks success status and returns' do
      it 'marks success status and returns' do
        expect(order).to receive(process_method)
        expect(model).to receive(mark_method)
        expect(model.send(method)).to eq(model.send(check_method))
      end
    end

    shared_examples 'does not do anything' do
      it 'does not do anything' do
        expect(order).to_not receive(process_method)
        expect(model).to_not receive(mark_method)
        expect(model).to_not receive(:create_transaction!)
        expect(model.send(method)).to be_nil
      end
    end

    shared_examples 'fulfillment method' do
      before :each do
        expect(model).to receive(:committed?).and_return(committed_status)
      end

      context 'committed' do
        let(:committed_status) { true }

        before :each do
          expect(model).to receive(status_method).and_return(status)
        end

        context 'status true' do
          let(:status) { true }

          include_examples 'marks success status and returns'
        end

        context 'status false' do
          let(:status) { false }

          include_examples 'does not do anything'
        end
      end

      context 'pending' do
        let(:committed_status) { false }

        include_examples 'does not do anything'
      end
    end

    describe '#prepare!' do
      let(:method) { :prepare! }
      let(:process_method) { :prepare! }
      let(:status_method) { :unmarked? }
      let(:check_method) { :prepared? }
      let(:mark_method) { :mark_prepared! }

      include_examples 'fulfillment method'
    end

    describe '#reverse!' do
      let(:method) { :reverse! }
      let(:process_method) { :reverse! }
      let(:status_method) { :fulfilled? }
      let(:check_method) { :reversed? }
      let(:mark_method) { :mark_reversed! }

      include_examples 'fulfillment method'
    end

    describe '#fulfill!' do
      let(:method) { :fulfill! }
      let(:process_method) { :fulfill! }
      let(:status_method) { :prepared? }
      let(:check_method) { :fulfilled? }
      let(:mark_method) { :mark_fulfilled! }

      let(:payment_transaction) { FactoryGirl.build :transaction, :payment, source: model }
      let(:refund_transaction) { FactoryGirl.build :transaction, :refund, source: model }

      before :each do
        expect(model).to receive(:committed?).and_return(committed_status)
        order.amount = order.item.amount(order.currency) * order.qty
      end

      context 'committed' do
        let(:committed_status) { true }

        before :each do
          expect(model).to receive(status_method).and_return(status)
        end

        context 'status true' do
          let(:status) { true }

          before :each do
            expect(model.payment_method).to receive(:enough?).with(model.amount).and_return(enough_status)
          end

          context 'enough amount' do
            let(:enough_status) { true }

            before :each do
              expect(model).to receive(:create_transaction!).and_return(payment_transaction)
              expect(payment_transaction).to receive(:commit!)
              expect(order).to receive(process_method).and_return(fulfillment_status)
              expect(model).to receive(mark_method)
            end

            context 'successful processing' do
              let(:fulfillment_status) { true }

              before :each do
                expect(model).to_not receive(:create_transaction!).with(-order.amount, order.currency)
              end

              it 'processes correctly' do
                expect(model.send(method)).to eq(model.send(check_method))
              end
            end

            context 'failed processing' do
              let(:fulfillment_status) { false }

              before :each do
                expect(model).to receive(:create_transaction!).with(-order.amount, order.currency).and_return(refund_transaction)
                expect(refund_transaction).to receive(:commit!)
              end

              it 'processes correctly' do
                expect(model.send(method)).to eq(model.send(check_method))
              end
            end
          end

          context 'not enought amount' do
            let(:enough_status) { false }

            include_examples 'does not do anything'
          end
        end

        context 'status false' do
          let(:status) { false }

          include_examples 'does not do anything'
        end
      end

      context 'pending' do
        let(:committed_status) { false }

        include_examples 'does not do anything'
      end
    end
  end
end
