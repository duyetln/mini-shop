require 'integration/spec_setup'

describe 'service api' do
  before :all do
    @pmethod_amount = 50_000
    @ids = {}
  end

  attr_reader :ids, :pmethod_amount

  def user; User.find ids[:user]; end
  def usd; Currency.find ids[:usd]; end
  def eur; Currency.find ids[:eur]; end
  def gbp; Currency.find ids[:gbp]; end
  def ppoint; Pricepoint.find ids[:ppoint]; end
  def discount; Discount.find ids[:discount]; end
  def price; Price.find ids[:price]; end
  def pitem; PhysicalItem.find ids[:pitem]; end
  def ditem; DigitalItem.find ids[:ditem]; end
  def bundle; Bundle.find ids[:bundle]; end
  def psi; StoreItem.find ids[:psi]; end
  def dsi; StoreItem.find ids[:dsi]; end
  def bsi; StoreItem.find ids[:bsi]; end
  def pmethod; PaymentMethod.find ids[:pmethod]; end
  def address; Address.find ids[:address]; end
  def purchase; Purchase.find ids[:purchase]; end
  def promotion; Promotion.find ids[:promotion]; end
  def batch; Batch.find ids[:batch]; end
  def coupon; Coupon.find ids[:coupon]; end

  describe Services::Accounts::Users do
    it 'creates new user' do
      expect do
        post '/users',
             user: {
               first_name: Faker::Name.first_name.gsub(/[^a-zA-Z]+/, ''),
               last_name: Faker::Name.last_name.gsub(/[^a-zA-Z]+/, ''),
               email: Faker::Internet.email,
               birthdate: '1990-11-15',
               password: Faker::Lorem.characters(20)
             }
      end.to change { User.count }.by(1)
      expect_status(200)
      ids[:user] = parsed_response[:id]
    end
  end

  describe Services::Mailing::Emails do
    before :each do
      expect do
      post '/emails',
           type: 'AccountActivationEmail',
           payload: {
             user_id: user.id
           }
      end.to change { Mail::TestMailer.deliveries.count }.by(1)
    end

    it { should have_sent_email.to(user.email) }
  end

  describe Services::Accounts::Users do
    it 'confirms the user' do
      expect do
        put "/users/#{user.uuid}/confirm/#{user.actv_code}"
      end.to change { user.confirmed? }.from(false).to(true)
      expect_status(200)
      ids[:user] = parsed_response[:id]
    end
  end

  describe Services::Inventory::Currencies do
    it 'creates USD currency' do
      expect do
        post '/currencies',
             currency: {
               code: 'USD'
             }
      end.to change { Currency.count }.by(1)
      expect_status(200)
      ids[:usd] = parsed_response[:id]
    end

    it 'creates EUR currency' do
      expect do
        post '/currencies',
             currency: {
               code: 'EUR'
             }
      end.to change { Currency.count }.by(1)
      expect_status(200)
      ids[:eur] = parsed_response[:id]
    end

    it 'creates GBP currency' do
      expect do
        post '/currencies',
             currency: {
               code: 'GBP'
             }
      end.to change { Currency.count }.by(1)
      expect_status(200)
      ids[:gbp] = parsed_response[:id]
    end
  end

  describe Services::Inventory::Pricepoints do
    it 'creates new pricepoint' do
      expect do
        post '/pricepoints',
             pricepoint: {
               name: rand_str
             }
      end.to change { Pricepoint.count }.by(1)
      expect_status(200)
      ids[:ppoint] = Pricepoint.find parsed_response[:id]
    end

    it 'adds new price for USD currency' do
      expect do
        post "/pricepoints/#{ppoint.id}/pricepoint_prices",
             pricepoint_price: {
               amount: amount,
               currency_id: usd.id
             }
      end.to change { ppoint.pricepoint_prices.count }.by(1)
      expect_status(200)
      ids[:ppoint] = parsed_response[:id]
    end

    it 'adds new price for EUR currency' do
      expect do
        post "/pricepoints/#{ppoint.id}/pricepoint_prices",
             pricepoint_price: {
               amount: amount,
               currency_id: eur.id
             }
      end.to change { ppoint.pricepoint_prices.count }.by(1)
      expect_status(200)
      ids[:ppoint] = parsed_response[:id]
    end

    it 'adds new price for EUR currency' do
      expect do
        post "/pricepoints/#{ppoint.id}/pricepoint_prices",
             pricepoint_price: {
               amount: amount,
               currency_id: gbp.id
             }
      end.to change { ppoint.pricepoint_prices.count }.by(1)
      expect_status(200)
      ids[:ppoint] = parsed_response[:id]
    end
  end

  describe Services::Inventory::Discounts do
    it 'creates new discount' do
      expect do
        post '/discounts',
             discount: {
               name: rand_str,
               rate: amount / 100.0
             }
      end.to change { Discount.count }.by(1)
      expect_status(200)
      ids[:discount] = parsed_response[:id]
    end
  end

  describe Services::Inventory::Prices do
    it 'creates new price' do
      expect do
        post '/prices',
             price: {
               name: rand_str,
               pricepoint_id: ppoint.id,
               discount_id: discount.id
             }
      end.to change { Price.count }.to(1)
      expect_status(200)
      ids[:price] = parsed_response[:id]
    end
  end

  describe Services::Inventory::PhysicalItems do
    it 'creates new physical item' do
      expect do
        post '/physical_items',
             physical_item: {
               title: rand_str,
               qty: 1_000
             }
      end.to change { PhysicalItem.count }.by(1)
      expect_status(200)
      ids[:pitem] = parsed_response[:id]
    end

    it 'activates physical item' do
      expect do
        put "/physical_items/#{pitem.id}/activate"
      end.to change { pitem.active? }.to(true)
    end
  end

  describe Services::Inventory::DigitalItems do
    it 'creates new digital item' do
      expect do
        post '/digital_items',
             digital_item: {
               title: rand_str
             }
      end.to change { DigitalItem.count }.by(1)
      expect_status(200)
      ids[:ditem] = parsed_response[:id]
    end

    it 'activates digital item' do
      expect do
        put "/digital_items/#{ditem.id}/activate"
      end.to change { ditem.active? }.to(true)
    end
  end

  describe Services::Inventory::Bundles do
    it 'creates new bundle' do
      expect do
        post '/bundles',
             bundle: {
               title: rand_str
             }
      end.to change { Bundle.count }.to(1)
      expect_status(200)
      ids[:bundle] = parsed_response[:id]
    end

    it 'adds physical item to bundle' do
      expect do
        post "/bundles/#{bundle.id}/bundleds",
             bundled: {
               item_type: pitem.class.name,
               item_id: pitem.id,
               qty: qty
             }
      end.to change { bundle.bundleds.count }.by(1)
      expect_status(200)
      ids[:bundle] = parsed_response[:id]
    end

    it 'adds digital item to bundle' do
      expect do
        post "/bundles/#{bundle.id}/bundleds",
             bundled: {
               item_type: ditem.class.name,
               item_id: ditem.id,
               qty: qty
             }
      end.to change { bundle.bundleds.count }.by(1)
      expect_status(200)
      ids[:bundle] = parsed_response[:id]
    end

    it 'activates bundle' do
      expect do
        put "/bundles/#{bundle.id}/activate"
      end.to change { bundle.active? }.to(true)
    end
  end

  describe Services::Inventory::Promotions do
    it 'creates promotion for digital item' do
      expect do
        post '/promotions',
             promotion: {
               name: rand_str,
               title: rand_str,
               description: rand_str,
               item_type: ditem.class.name,
               item_id: ditem.id,
               price_id: price.id
             }
      end.to change { Promotion.count }.by(1)
      expect_status(200)
      ids[:promotion] = parsed_response[:id]
    end

    it 'activates promotion' do
      expect do
        put "/promotions/#{promotion.id}/activate"
      end.to change { promotion.active? }.to(true)
    end

    it 'creates batch for promotion' do
      expect do
        post "/promotions/#{promotion.id}/batches",
             batch: {
               name: rand_str,
               size: qty
             }
      end.to change { promotion.batches.count }.by(1)
      expect_status(200)
      ids[:batch] = parsed_response[:id]
    end
  end

  describe Services::Inventory::Batches do
    it 'activates batch' do
      expect do
        put "/batches/#{batch.id}/activate"
      end.to change { batch.active? }.to(true)
      expect_status(200)
      ids[:batch] = parsed_response[:id]
    end

    it 'returns coupons for batch' do
      expect do
        get "/batches/#{batch.id}/coupons"
      end.to_not change { batch.coupons.count }
      expect_status(200)
      expect(parsed_response.count).to eq(batch.coupons.count)
      ids[:coupon] = parsed_response.first[:id]
    end
  end

  describe Services::Inventory::StoreItems do
    it 'creates store item for physical item' do
      expect do
        post '/store_items',
             store_item: {
               name: rand_str,
               item_type: pitem.class.name,
               item_id: pitem.id,
               price_id: price.id
             }
      end.to change { StoreItem.count }.by(1)
      expect_status(200)
      ids[:psi] = parsed_response[:id]
    end

    it 'creates store item for digital item' do
      expect do
        post '/store_items',
             store_item: {
               name: rand_str,
               item_type: ditem.class.name,
               item_id: ditem.id,
               price_id: price.id
             }
      end.to change { StoreItem.count }.by(1)
      expect_status(200)
      ids[:dsi] = parsed_response[:id]
    end

    it 'creates store item for bundle item' do
      expect do
        post '/store_items',
             store_item: {
               name: rand_str,
               item_type: bundle.class.name,
               item_id: bundle.id,
               price_id: price.id
             }
      end.to change { StoreItem.count }.by(1)
      expect_status(200)
      ids[:bsi] = parsed_response[:id]
    end
  end

  describe Services::Accounts::Users do
    it 'creates new payment method' do
      expect do
        post "/users/#{user.id}/payment_methods",
             payment_method: {
               name: rand_str,
               balance: 0,
               currency_id: usd.id
             }
      end.to change { PaymentMethod.count }.by(1)
      expect_status(200)
      ids[:pmethod] = parsed_response[:id]
    end

    it 'creates new address' do
      expect do
        post "/users/#{user.id}/addresses",
             address: {
               line1: Faker::Address.street_address,
               city: Faker::Address.city,
               region: Faker::Address.state,
               postal_code: Faker::Address.postcode,
               country: Faker::Address.country
             }
      end.to change { Address.count }.by(1)
      expect_status(200)
      ids[:address] = parsed_response[:id]
    end

    it 'creates new purchase' do
      expect do
        post "/users/#{user.id}/purchases",
             purchase: {
               payment_method_id: pmethod.id,
               billing_address_id: address.id,
               shipping_address_id: address.id
             }
      end.to change { Purchase.count }.by(1)
      expect_status(200)
      ids[:purchase] = parsed_response[:id]
    end
  end

  describe Services::Shopping::Purchases do
    it 'adds physical item to purchase' do
      expect do
        post "/purchases/#{purchase.id}/orders",
             order: {
               item_type: psi.item.class.name,
               item_id: psi.item.id,
               amount: psi.amount(usd) * 1,
               currency_id: usd.id,
               qty: 1
             }
      end.to change { purchase.orders.count }.by(1)
      expect_status(200)
      ids[:purchase] = parsed_response[:id]
    end

    it 'adds digital item to purchase' do
      expect do
        post "/purchases/#{purchase.id}/orders",
             order: {
               item_type: dsi.item.class.name,
               item_id: dsi.item.id,
               amount: dsi.amount(usd) * 1,
               currency_id: usd.id,
               qty: 1
             }
      end.to change { purchase.orders.count }.by(1)
      expect_status(200)
      ids[:purchase] = parsed_response[:id]
    end

    it 'adds bundle to purchase' do
      expect do
        post "/purchases/#{purchase.id}/orders",
             order: {
               item_type: bsi.item.class.name,
               item_id: bsi.item.id,
               amount: bsi.amount(usd) * 1,
               currency_id: usd.id,
               qty: 1
             }
      end.to change { purchase.orders.count }.by(1)
      expect_status(200)
      ids[:purchase] = parsed_response[:id]
    end

    it 'adds coupon to purchase' do
      expect do
        post "/purchases/#{purchase.id}/orders",
             order: {
               item_type: coupon.class.name,
               item_id: coupon.id,
               amount: promotion.amount(usd) * 1,
               currency_id: usd.id,
               qty: 1
             }
      end.to change { purchase.orders.count }.by(1)
      expect_status(200)
      ids[:purchase] = parsed_response[:id]
    end

    it 'submits the purchase' do
      expect do
        put "/purchases/#{purchase.id}/submit"
      end.to_not change { purchase.orders.all?(&:unmarked?) }
      expect(purchase).to be_committed
      expect_status(200)
      ids[:purchase] = parsed_response[:id]
    end
  end

  describe Services::Mailing::Emails do
    before :each do
      expect do
      post '/emails',
           type: 'PurchaseReceiptEmail',
           payload: {
             purchase_id: purchase.id
           }
      end.to change { Mail::TestMailer.deliveries.count }.by(1)
    end

    it { should have_sent_email.to(purchase.user.email) }
  end

  describe Services::Shopping::PaymentMethods do
    it 'updates payment method balance' do
      expect do
        put "/payment_methods/#{pmethod.id}",
            payment_method: {
              balance: pmethod_amount
            }
      end.to change { pmethod.balance }.to(pmethod_amount)
      expect_status(200)
      ids[:pmethod] = parsed_response[:id]
    end
  end

  describe Services::Shopping::Purchases do
    it 'submits the purchase' do
      expect do
        put "/purchases/#{purchase.id}/submit"
      end.to change { purchase.orders.all?(&:fulfilled?) }.from(false).to(true)
      expect(purchase.orders.any?(&:unmarked?)).to be_false
      expect(purchase).to be_committed
      expect_status(200)
      ids[:purchase] = parsed_response[:id]
    end
  end

  describe Services::Accounts::Users do
    it 'returns all user ownerships' do
      expect do
        get "/users/#{user.id}/ownerships"
      end.to_not change { user.ownerships.count }
      expect_status(200)
      expect(parsed_response.count).to eq(3)
    end

    it 'returns all user ownerships' do
      expect do
        get "/users/#{user.id}/shipments"
      end.to_not change { user.shipments.count }
      expect_status(200)
      expect(parsed_response.count).to eq(2)
    end
  end

  describe Services::Shopping::Purchases do
    it 'reverses the purchase' do
      expect do
        put "/purchases/#{purchase.id}/return"
      end.to change { purchase.orders.all?(&:reversed?) }.from(false).to(true)
      expect(purchase.orders.any?(&:unmarked?)).to be_false
      expect(purchase).to be_committed
      expect_status(200)
      ids[:purchase] = parsed_response[:id]
    end

    it 'refunds the purchase fully' do
      expect(pmethod.balance).to eq(pmethod_amount)
    end
  end

  describe Services::Mailing::Emails do
    before :each do
      expect do
      post '/emails',
           type: 'PurchaseStatusEmail',
           payload: {
             purchase_id: purchase.id
           }
      end.to change { Mail::TestMailer.deliveries.count }.by(1)
    end

    it { should have_sent_email.to(purchase.user.email) }
  end

  describe Services::Accounts::Users do
    it 'returns all user ownerships' do
      expect do
        get "/users/#{user.id}/ownerships"
      end.to_not change { user.ownerships.count }
      expect_status(200)
      expect(parsed_response.count).to eq(0)
    end

    it 'returns all user ownerships' do
      expect do
        get "/users/#{user.id}/shipments"
      end.to_not change { user.shipments.count }
      expect_status(200)
      expect(parsed_response.count).to eq(2)
    end
  end
end
