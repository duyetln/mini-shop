require 'spec_helper'
require 'spec/models/shared/committable'

describe Purchase do

  let(:orders) { saved_model.orders }
  let(:order) { orders.sample }

  it_behaves_like 'committable model'

  it { should have_readonly_attribute(:user_id) }

  it { should have_many(:orders) }
  it { should belong_to(:payment_method) }
  it { should belong_to(:billing_address).class_name('Address') }
  it { should belong_to(:shipping_address).class_name('Address') }
  it { should belong_to(:payment) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:user) }

  context 'pending' do
    let(:subject) { saved_model }

    it { should be_pending }
    it { should_not validate_presence_of(:payment_method) }
    it { should_not validate_presence_of(:billing_address) }
    it { should_not validate_presence_of(:shipping_address) }
    it { should validate_uniqueness_of(:committed).scoped_to(:user_id) }
  end

  context 'committed' do
    let :subject do
      saved_model.commit!
      saved_model
    end

    it { should be_committed }
    it { should validate_presence_of(:payment_method) }
    it { should validate_presence_of(:billing_address) }
    it { should validate_presence_of(:shipping_address) }
  end

  describe '#payment_method_currency' do
    it 'delegates to #payment_method' do
      expect(saved_model.payment_method_currency).to eq(saved_model.payment_method.currency)
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
    context 'pending' do
      before :each do
        sf_item.save!
        saved_model.orders << FactoryGirl.build(:order, 
          purchase: saved_model, 
          item: sf_item,
          qty: qty, 
          currency: currency
        )
        saved_model.save!
      end

      it 'adds or updates item' do
        expect(orders).to receive(:add_or_update).with(sf_item, qty, false).and_yield(order)
        expect(order).to receive(:currency=).with(currency)
        saved_model.add_or_update(sf_item, currency, qty)
      end
    end

    context 'committed' do
      it 'does not add or update item' do
        saved_model.commit!
        expect(orders).to_not receive(:add_or_update)
        saved_model.add_or_update(sf_item, currency, qty)
      end
    end
  end

  describe '#remove' do
    context 'pending' do
      before :each do
        sf_item.save!
        saved_model.save!
        saved_model.add_or_update(sf_item, currency, qty)
      end

      it 'removes the item' do
        expect(orders).to receive(:retrieve).with(sf_item).and_yield(order)
        expect(order).to receive(:delete!)
        saved_model.remove(sf_item)
      end
    end

    context 'committed' do
      it 'does not remove the item' do
        saved_model.commit!
        expect(orders).to_not receive(:retrieve)
        saved_model.remove(sf_item)
      end
    end
  end

  describe '#amount' do
    let(:model_args) { [:purchase, :orders] }

    it 'totals order amount' do
      total_amount = saved_model.orders.reduce(BigDecimal('0.0')) do |a, e| 
        a += Currency.exchange(
          e.amount, 
          e.currency, 
          currency
        )
      end
      expect(saved_model.amount(currency)).to eq(total_amount)
    end
  end

  describe '#tax' do
    let(:model_args) { [:purchase, :orders] }

    it 'totals order tax' do
      total_tax = saved_model.orders.reduce(BigDecimal('0.0')) do |a, e| 
        a += Currency.exchange(
          e.tax, 
          e.currency, 
          currency
        )
      end
      expect(saved_model.tax(currency)).to eq(total_tax)
    end
  end

end
