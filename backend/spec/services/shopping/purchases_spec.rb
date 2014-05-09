require 'services/spec_setup'
require 'spec/services/shared/errors'

describe Services::Shopping::Purchases do
  let(:user) { FactoryGirl.create(:user).reload }
  let(:purchase) { Purchase.current(user).first! }
  let(:item) { FactoryGirl.create :storefront_item, :physical_item }
  let(:qty) { 2 }
  let(:id) { user.id }

  describe 'get /users/:id/purchases' do
    let(:method) { :get }
    let(:path) { "/users/#{id}/purchases" }

    include_examples 'invalid id'

    context 'valid id' do
      it 'returns the purchases' do
        send_request
        expect_status(200)
        expect_response(user.purchases.map do |purchase|
          PurchaseSerializer.new(purchase)
        end.to_json)
      end
    end
  end

  describe 'get /users/:id/orders' do
    let(:method) { :get }
    let(:path) { "/users/#{id}/orders" }

    include_examples 'invalid id'

    context 'valid id' do
      it 'returns the orders' do
        send_request
        expect_status(200)
        expect_response(user.purchases.map(&:orders).flatten.map do |order|
          OrderSerializer.new(order)
        end.to_json)
      end
    end
  end

  describe 'post /users/:user_id/purchases' do
    let(:method) { :post }
    let(:path) { "/users/#{id}/purchases" }
    let(:address) { FactoryGirl.create :address, user: user }
    let(:params) { { purchase: { billing_address_id: address.id } } }

    include_examples 'invalid id'

    context 'no current purchase' do
      context 'valid parameters' do
        it 'creates a pending purchase' do
          expect { send_request }.to change { user.purchases.count }.by(1)
          expect_status(200)
          expect_response(PurchaseSerializer.new(purchase).to_json)
        end

        it 'sets the attributes' do
          send_request
          expect(purchase.billing_address).to eq(address)
          expect(purchase).to be_pending
        end
      end

      context 'invalid parameters' do
        let(:params) { { purchase: { user_id: nil } } }

        it 'does not create a pending purchase' do
          expect { send_request }.to_not change { user.purchases.count }
        end

        include_examples 'bad request'
      end
    end

    context 'existing current purchase' do
      before :each do
        Purchase.current(user).first_or_create!
      end

      shared_examples 'existing current purchase' do
        it 'does not create a current purchase' do
          expect { send_request }.to_not change { user.purchases.count }
        end

        it 'does not update the current purchase' do
          expect { send_request }.to_not change { purchase }
        end

        it 'returns the current purchase' do
          send_request
          expect_status(200)
          expect_response(PurchaseSerializer.new(purchase).to_json)
        end
      end

      context 'valid parameters' do
        include_examples 'existing current purchase'
      end

      context 'invalid parameters' do
        let(:params) { { purchase: { user_id: nil } } }

        include_examples 'existing current purchase'
      end
    end
  end

  describe 'get /users/:id/purchases/current' do
    let(:method) { :get }
    let(:path) { "/users/#{id}/purchases/current" }

    include_examples 'invalid id'

    context 'valid id' do
      context 'no current purchase' do
        include_examples 'not found'
      end

      context 'existing current purchase' do
        before :each do
          Purchase.current(user).first_or_create!
        end

        it 'returns the current purchase' do
          send_request
          expect_status(200)
          expect_response(PurchaseSerializer.new(purchase).to_json)
        end
      end
    end
  end

  describe 'put /users/:id/purchases/current' do
    let(:method) { :put }
    let(:path) { "/users/#{id}/purchases/current" }
    let(:address) { FactoryGirl.create :address, user: user }
    let(:params) { { purchase: { billing_address_id: address.id } } }

    include_examples 'invalid id'

    context 'valid id' do
      context 'no current purchase' do
        include_examples 'not found'
      end

      context 'existing current purchase' do
        before :each do
          Purchase.current(user).first_or_create!
        end

        context 'valid parameters' do
          it 'updates the current purchase' do
            send_request
            expect(purchase.billing_address).to eq(address)
          end

          it 'returns the current purchase' do
            send_request
            expect_status(200)
            expect_response(PurchaseSerializer.new(purchase).to_json)
          end
        end

        context 'invalid parameters' do
          let(:params) { { purchase: { user_id: nil } } }

          include_examples 'bad request'
        end
      end
    end
  end

  describe 'post /users/:id/purchases/current/orders' do
    let(:method) { :post }
    let(:path) { "/users/#{id}/purchases/current/orders" }

    include_examples 'invalid id'

    context 'valid id' do
      context 'no current purchase' do
        include_examples 'not found'
      end

      context 'existing current purchase' do
        before :each do
          Purchase.current(user).first_or_create!
        end

        let(:item_type) { item.class.name }
        let(:item_id) { item.id }
        let(:currency_id) { currency.id }
        let :params do
          {
            order: {
              item_type: item_type,
              item_id: item_id,
              currency_id: currency_id,
              qty: qty
            }
          }
        end

        context 'invalid item type' do
          let(:item_type) { rand_str }

          include_examples 'bad request'
        end

        context 'invalid item id' do
          let(:item_id) { rand_str }

          include_examples 'not found'
        end

        context 'invalid currency id' do
          let(:currency_id) { rand_str }

          include_examples 'not found'
        end

        context 'valid parameters' do
          it 'creates new order' do
            expect { send_request }.to change { purchase.orders.count }.by(1)
            expect_status(200)
            expect_response(PurchaseSerializer.new(purchase).to_json)
          end

          it 'sets order attributes correctly' do
            send_request
            order = purchase.orders.last
            expect(order.item).to eq(item)
            expect(order.currency).to eq(currency)
            expect(order.qty).to eq(qty)
          end
        end
      end
    end
  end

  describe 'delete /users/:id/purchases/current/orders/:order_id' do
    let(:method) { :delete }
    let(:path) { "/users/#{id}/purchases/current/orders/#{order_id}" }
    let(:order_id) { rand_str }

    include_examples 'invalid id'

    context 'valid id' do
      context 'no current purchase' do
        include_examples 'not found'
      end

      context 'existing current purchase' do
        before :each do
          Purchase.current(user).first_or_create!
        end

        context 'invalid order id' do
          include_examples 'not found'
        end

        context 'valid order_id' do
          let(:item) { FactoryGirl.create :storefront_item }
          let(:order) { purchase.orders.last }
          let(:order_id) { order.id }

          before :each do
            purchase.add_or_update(item, currency, qty)
          end

          it 'removes the order' do
            expect { send_request }.to change { purchase.orders.count }.by(-1)
            expect_status(200)
            expect_response(PurchaseSerializer.new(purchase).to_json)
          end
        end
      end
    end
  end

  describe 'put /users/:id/purchases/current/submit' do
    let(:method) { :put }
    let(:path) { "/users/#{id}/purchases/current/submit" }

    include_examples 'invalid id'

    context 'valid id' do
      context 'no current purchase' do
        include_examples 'not found'
      end

      context 'existing current purchase' do
        before :each do
          FactoryGirl.create(:purchase, user: user).add_or_update(item, currency, qty)
        end

        it 'commits and fulfills the purchase' do
          expect { send_request }.to change { purchase.reload.committed? }.to(true)
          expect(purchase.orders.all?(&:fulfilled?)).to be_true
          expect_status(200)
          expect_response(PurchaseSerializer.new(purchase).to_json)
        end
      end
    end
  end

  describe 'get /users/:id/purchases/:purchase_id' do
    let(:method) { :get }
    let(:path) { "/users/#{id}/purchases/#{purchase_id}" }
    let(:purchase_id) { rand_str }

    include_examples 'invalid id'

    context 'valid id' do
      context 'invalid purchase id' do
        include_examples 'not found'
      end

      context 'valid purchase id' do
        before :each do
          Purchase.current(user).first_or_create!
        end

        let(:purchase_id) { purchase.id }

        it 'returns the purchase' do
          send_request
          expect_status(200)
          expect_response(PurchaseSerializer.new(purchase).to_json)
        end
      end
    end
  end

  describe 'put /users/:id/purchases/:purchase_id/return' do
    let(:method) { :put }
    let(:path) { "/users/#{id}/purchases/#{purchase_id}/return" }
    let(:purchase_id) { rand_str }

    include_examples 'invalid id'

    context 'valid id' do
      context 'invalid purchase id' do
        include_examples 'not found'
      end

      context 'valid purchase id' do
        before :each do
          FactoryGirl.create(:purchase, user: user).add_or_update(item, currency, qty)
        end

        let(:purchase_id) { purchase.id }

        context 'uncommitted purchase' do
          it 'does nothing' do
            expect { send_request }.to_not change { purchase.reload.orders.all?(&:unmarked?) }
            expect_status(200)
            expect_response(PurchaseSerializer.new(purchase).to_json)
          end
        end

        context 'committed, fulfilled purchase' do
          before :each do
            purchase.commit!
            purchase.fulfill!
          end

          it 'reverses the purchase' do
            expect { send_request }.to change { purchase.reload.orders.all?(&:reversed?) }.to(true)
            expect_status(200)
            expect_response(PurchaseSerializer.new(purchase).to_json)
          end
        end
      end
    end

    describe 'put /users/:id/purchases/:purchase_id/orders/:order_id/return' do
      let(:method) { :put }
      let(:path) { "/users/#{id}/purchases/#{purchase_id}/orders/#{order_id}/return" }
      let(:purchase_id) { rand_str }
      let(:order_id) { rand_str }

      include_examples 'invalid id'

      context 'valid id' do
        context 'invalid purchase id' do
          include_examples 'not found'
        end

        context 'valid purchase id' do
          before :each do
            FactoryGirl.create(:purchase, user: user).add_or_update(item, currency, qty)
          end

          let(:purchase_id) { purchase.id }

          context 'invalid order id' do
            include_examples 'not found'
          end

          context 'valid order id' do
            let(:order) { purchase.orders.last }
            let(:order_id) { order.id }

            context 'uncommitted purchase' do
              it 'does nothing' do
                expect { send_request }.to_not change { purchase.reload.orders.all?(&:unmarked?) }
                expect_status(200)
                expect_response(PurchaseSerializer.new(purchase).to_json)
              end
            end

            context 'committed, fulfilled purchase' do
              before :each do
                purchase.commit!
                purchase.fulfill!
              end

              it 'reverses the order' do
                expect { send_request }.to change { order.reload.reversed? }.to(true)
                expect_status(200)
                expect_response(PurchaseSerializer.new(purchase).to_json)
              end
            end
          end
        end
      end
    end
  end
end
