require 'integration/spec_setup'
require 'spec/integration/shared/fulfillment'

describe 'purchase flow' do
  before :all do
    @qty = rand(5) + 1
    @user = FactoryGirl.create :user
    @usd = FactoryGirl.create :usd
    @eur = FactoryGirl.create :eur
    @pitem = FactoryGirl.create :physical_item, qty: @qty * 10
    @ditem = FactoryGirl.create :digital_item
    @bitem = FactoryGirl.create :bundle_item
    @psfi = FactoryGirl.create :storefront_item, item: @pitem
    @dsfi = FactoryGirl.create :storefront_item, item: @ditem
    @bsfi = FactoryGirl.create :storefront_item, item: @bitem
    @purchase = Purchase.pending_purchase(@user)
    @address = FactoryGirl.create :address, user: @user
    @pmethod = FactoryGirl.create :payment_method, user: @user, currency: @usd
  end

  let(:user) { @user }
  let(:usd) { @usd }
  let(:eur) { @eur }
  let(:physical_item) { @pitem }
  let(:digital_item) { @ditem }
  let(:bundle_item) { @bitem }
  let(:psfi) { @psfi }
  let(:dsfi) { @dsfi }
  let(:bsfi) { @bsfi }
  let(:purchase) { @purchase }
  let(:address) { @address }
  let(:pmethod) { @pmethod }
  let(:qty) { @qty }

  describe 'user' do
    it 'confirms and changes status' do
      expect { user.confirm! }.to change { user.confirmed? }.to(true)
    end
  end

  describe 'bundle item' do
    it 'adds and updates items' do
      expect { bundle_item.add_or_update(physical_item, qty) }.to change { bundle_item.bundlings.count }.by(1)
      expect { bundle_item.add_or_update(digital_item, qty) }.to change { bundle_item.bundlings.count }.by(1)
      expect(bundle_item).to be_available
    end
  end

  describe 'purchase' do
    it 'is pending' do
      expect(purchase).to be_pending
    end

    it 'adds and updates orders' do
      expect { purchase.add_or_update(psfi, eur, physical_item.qty + 1) }.to change { purchase.orders.count }.by(1)
      expect { purchase.add_or_update(dsfi, usd, qty) }.to change { purchase.orders.count }.by(1)
      expect { purchase.add_or_update(bsfi, usd, qty) }.to change { purchase.orders.count }.by(1)
    end

    it 'removes orders' do
      expect { purchase.remove(bsfi) }.to change { purchase.orders.reload.count }.by(-1)
    end

    it 'adds and updates orders' do
      expect { purchase.add_or_update(bsfi, usd, qty) }.to change { purchase.orders.count }.by(1)
    end
  end

  describe 'fulfillment' do
    it 'commits purchase' do
      purchase.payment_method = pmethod
      purchase.billing_address = address
      purchase.shipping_address = address
      expect { purchase.commit! }.to change { purchase.committed? }.to(true)
    end

    it 'has enough balance in payment method' do
      expect { purchase.payment_method.enough?(purchase.total) }.to be_true
    end

    it 'can be fulfilled' do
      expect(purchase.fulfill!).to_not be_nil
    end

    describe 'physical item order' do
      let(:order) { purchase.orders.retrieve(psfi) }

      include_examples 'failed order fulfillment'
    end

    describe 'digital item order' do
      let(:order) { purchase.orders.retrieve(dsfi) }

      include_examples 'successful order fulfillment'

      describe 'digital item fulfillment' do
        let(:item) { digital_item }
        let(:qty) { order.qty }
        let(:result_class) { Ownership }

        include_examples 'fulfillment processing'
      end
    end

    describe 'bundle item order' do
      let(:order) { purchase.orders.retrieve(bsfi) }

      include_examples 'successful order fulfillment'

      describe 'physical item fulfillment' do
        let(:item) { physical_item }
        let(:qty) { order.qty * bsfi.item.bundlings.retrieve(item).qty }
        let(:result_class) { Shipment }

        include_examples 'fulfillment processing'

        it 'sets the shippment address' do
          expect(result.shipping_address).to eq(order.shipping_address)
        end
      end

      describe 'digital item fulfillment' do
        let(:item) { digital_item }
        let(:qty) { order.qty * bsfi.item.bundlings.retrieve(item).qty }
        let(:result_class) { Ownership }

        include_examples 'fulfillment processing'
      end
    end
  end

  describe 'transactions' do
    it 'includes payment' do
      expect(purchase.payment).to be_present
      expect(purchase.payment.amount).to eq(purchase.total(pmethod.currency))
      expect(purchase.payment.currency).to eq(pmethod.currency)
    end

    it 'includes refunds' do
      expect(purchase.transactions.any?(&:refund?)).to be_true
    end

    it 'is committed' do
      expect(purchase.transactions.all?(&:committed?)).to be_true
    end
  end
end
