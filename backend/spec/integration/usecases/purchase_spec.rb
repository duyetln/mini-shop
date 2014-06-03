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
    @bitem = FactoryGirl.create :bundle
    @psi = FactoryGirl.create :store_item, item: @pitem
    @dsi = FactoryGirl.create :store_item, item: @ditem
    @bsi = FactoryGirl.create :store_item, item: @bitem
    @purchase = Purchase.current(@user).first_or_create!
    @address = FactoryGirl.create :address, user: @user
    @pmethod = FactoryGirl.create :payment_method, user: @user, currency: @usd
  end

  attr_reader :qty

  def user; @user.reload; end
  def usd; @usd.reload; end
  def eur; @eur.reload; end
  def pitem; @pitem.reload; end
  def ditem; @ditem.reload; end
  def bundle; @bitem.reload; end
  def psi; @psi.reload; end
  def dsi; @dsi.reload; end
  def bsi; @bsi.reload; end
  def purchase; @purchase.reload; end
  def address; @address.reload; end
  def pmethod; @pmethod.reload; end

  describe 'user' do
    it 'confirms and changes status' do
      expect { user.confirm! }.to change { user.confirmed? }.to(true)
    end
  end

  shared_examples 'item activation' do
    it 'activates the item' do
      expect { item.activate! }.to change { item.active? }.from(false).to(true)
    end

    it 'makes the item available' do
      expect(item).to be_available
    end
  end

  describe 'physical item' do
    let(:item) { pitem }

    include_examples 'item activation'
  end

  describe 'digital item' do
    let(:item) { ditem }

    include_examples 'item activation'
  end

  describe 'bundle' do
    let(:item) { bundle }

    it 'adds and updates items' do
      expect { bundle.add_or_update(pitem, qty) }.to change { bundle.bundleds.count }.by(1)
      expect { bundle.add_or_update(ditem, qty) }.to change { bundle.bundleds.count }.by(1)
    end

    include_examples 'item activation'
  end

  describe 'purchase' do
    it 'is pending' do
      expect(purchase).to be_pending
    end

    it 'adds and updates orders' do
      expect { purchase.add_or_update(psi.item, psi.amount(eur) * (pitem.qty + 1), eur, pitem.qty + 1) }.to change { purchase.orders.count }.by(1)
      expect { purchase.add_or_update(dsi.item, dsi.amount(usd) * qty, usd, qty) }.to change { purchase.orders.count }.by(1)
      expect { purchase.add_or_update(bsi.item, bsi.amount(usd) * qty, usd, qty) }.to change { purchase.orders.count }.by(1)
    end

    it 'removes orders' do
      expect { purchase.remove(bsi) }.to change { purchase.orders.reload.count }.by(-1)
    end

    it 'adds and updates orders' do
      expect { purchase.add_or_update(bsi.item, bsi.amount(usd) * qty, usd, qty) }.to change { purchase.orders.count }.by(1)
    end
  end

  describe 'fulfillment' do
    it 'commits purchase' do
      purchase = self.purchase
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
      def order; purchase.orders.retrieve(pitem); end

      include_examples 'failed order fulfillment'
    end

    describe 'digital item order' do
      def order; purchase.orders.retrieve(ditem); end

      include_examples 'successful order fulfillment'

      describe 'digital item fulfillment' do
        def item; ditem; end
        def qty; order.qty; end
        def result_class; Ownership; end

        include_examples 'fulfillment processing'
      end
    end

    describe 'bundle order' do
      def order; purchase.orders.retrieve(bundle); end

      include_examples 'successful order fulfillment'

      describe 'physical item fulfillment' do
        def item; pitem; end
        def qty; order.qty * bundle.bundleds.retrieve(item).qty; end
        def result_class; Shipment; end

        include_examples 'fulfillment processing'

        it 'sets the shippment address' do
          expect(result.shipping_address).to eq(order.shipping_address)
        end
      end

      describe 'digital item fulfillment' do
        def item; ditem; end
        def qty; order.qty * bundle.bundleds.retrieve(item).qty; end
        def result_class; Ownership; end

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

  describe 'user' do
    it 'has 2 ownerships' do
      expect(user.ownerships.count).to eq(2)
    end

    it 'has 1 shipment' do
      expect(user.shipments.count).to eq(1)
    end

    it 'has 2 transactions' do
      expect(user.transactions.count).to eq(2)
    end
  end

  describe 'digital item order' do
    def order; purchase.orders.retrieve(ditem); end

    it 'can be reversed' do
      expect(purchase.reverse!(order)).to_not be_nil
    end

    include_examples 'successful order reversal'
  end

  describe 'bundle order' do
    def order; purchase.orders.retrieve(bundle); end
    def qty; order.qty * bundle.bundleds.retrieve(pitem).qty; end

    it 'can be reversed' do
      expect { purchase.reverse!(order) }.to change { pitem.qty }.by(qty)
    end

    include_examples 'successful order reversal'
  end

  describe 'user' do
    it 'has 0 ownerships' do
      expect(user.ownerships.count).to eq(0)
    end

    it 'has 1 shipment' do
      expect(user.shipments.count).to eq(1)
    end

    it 'has 4 transactions' do
      expect(user.transactions.count).to eq(4)
    end
  end
end
