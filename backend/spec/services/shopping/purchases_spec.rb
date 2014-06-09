require 'services/spec_setup'
require 'spec/services/shared/errors'

describe Services::Shopping::Purchases do
  let(:qty) { 2 }
  let! :item do
    FactoryGirl.create(
      *[
        [
          [:bundle, :bundleds],
          :digital_item,
          :physical_item
        ].sample
      ].flatten
    )
  end

  before :each do
    PhysicalItem.all.each do |i|
      expect { i.activate! }.to change { i.active? }.to(true)
    end
    DigitalItem.all.each do |i|
      expect { i.activate! }.to change { i.active? }.to(true)
    end
    Bundle.all.each do |i|
      expect { i.activate! }.to change { i.active? }.to(true)
    end
    item.reload
  end

  describe 'get /users/:id/purchases' do
    let(:method) { :get }
    let(:path) { "/users/#{id}/purchases" }

    include_examples 'invalid id'

    context 'valid id' do
      let(:user) { FactoryGirl.create(:user) }
      let(:id) { user.id }

      before :each do
        FactoryGirl.create :purchase, user: user
      end

      it 'returns the purchases' do
        send_request
        expect_status(200)
        expect_response(user.purchases.map do |purchase|
          PurchaseSerializer.new(purchase)
        end.to_json)
      end
    end
  end

  describe 'post /users/:id/purchases' do
    let(:method) { :post }
    let(:path) { "/users/#{id}/purchases" }

    include_examples 'invalid id'

    context 'valid id' do
      let(:user) { FactoryGirl.create(:user) }
      let(:id) { user.id }

      context 'valid parameters' do
        let(:address) { FactoryGirl.create :address, user: user }
        let(:params) { { purchase: { billing_address_id: address.id } } }

        it 'creates new purchase' do
          expect { send_request }.to change { user.purchases.count }.by(1)
          expect_status(200)
          expect_response(PurchaseSerializer.new(user.purchases.last).to_json)
        end

        it 'sets the attributes' do
          send_request
          expect(user.purchases.last.billing_address).to eq(address)
          expect(user.purchases.last).to be_pending
        end
      end
    end
  end

  describe 'put /purchases/:id' do
    let(:method) { :put }
    let(:path) { "/purchases/#{id}" }

    include_examples 'invalid id'

    context 'valid id' do
      let(:purchase) { FactoryGirl.create :purchase }
      let(:id) { purchase.id }

      context 'pending' do
        before :each do
          expect(purchase).to be_pending
        end

        context 'valid parameters' do
          let(:address) { FactoryGirl.create :address }
          let(:params) { { purchase: { billing_address_id: address.id } } }

          it 'updates the current purchase' do
            send_request
            expect(purchase.reload.billing_address).to eq(address)
          end

          it 'returns the current purchase' do
            send_request
            expect_status(200)
            expect_response(PurchaseSerializer.new(purchase.reload).to_json)
          end
        end

        context 'invalid parameters' do
          let(:params) { { purchase: { user_id: nil } } }

          include_examples 'bad request'
        end
      end

      context 'committed' do
        before :each do
          expect { purchase.commit! }.to change { purchase.committed? }.to(true)
        end

        context 'valid parameters' do
          let(:address) { FactoryGirl.create :address, user: user }
          let(:params) { { purchase: { billing_address_id: address.id } } }

          include_examples 'unprocessable'

          it 'does not update the purchase' do
            expect { send_request }.to_not change { purchase.reload.attributes }
          end
        end

        context 'invalid parameters' do
          let(:params) { { purchase: { user_id: nil } } }

          include_examples 'unprocessable'
        end
      end
    end
  end

  describe 'post /purchases/:id/orders' do
    let(:method) { :post }
    let(:path) { "/purchases/#{id}/orders" }

    include_examples 'invalid id'

    context 'valid id' do
      let(:purchase) { FactoryGirl.create :purchase }
      let(:id) { purchase.id }

      let(:item_type) { item.class.name }
      let(:item_id) { item.id }
      let(:currency_id) { currency.id }
      let :params do
        {
          order: {
            item_type: item_type,
            item_id: item_id,
            amount: amount,
            currency_id: currency_id,
            qty: qty
          }
        }
      end

      shared_examples 'invalid item type' do
        context 'invalid item type' do
          let(:item_type) { rand_str }

          include_examples 'bad request'
        end
      end

      shared_examples 'invalid item id' do
        context 'invalid item id' do
          let(:item_id) { rand_str }

          include_examples 'not found'
        end
      end

      shared_examples 'invalid currency id' do
        context 'invalid currency id' do
          let(:currency_id) { rand_str }

          include_examples 'not found'
        end
      end

      context 'pending' do
        before :each do
          expect(purchase).to be_pending
        end

        include_examples 'invalid item type'
        include_examples 'invalid item id'
        include_examples 'invalid currency id'

        context 'valid parameters' do
          it 'creates new order' do
            expect { send_request }.to change { purchase.orders.count }.by(1)
            expect_status(200)
            expect_response(PurchaseSerializer.new(purchase).to_json)
          end

          it 'sets order attributes correctly' do
            send_request
            order = purchase.reload.orders.last
            expect(order.item).to eq(item)
            expect(order.amount).to eq(amount)
            expect(order.currency).to eq(currency)
            expect(order.qty).to eq(qty)
          end
        end
      end

      context 'committed' do
        before :each do
          expect { purchase.commit! }.to change { purchase.committed? }.to(true)
        end

        include_examples 'invalid item type'
        include_examples 'invalid item id'
        include_examples 'invalid currency id'

        context 'valid parameters' do
          include_examples 'unprocessable'

          it 'does not create new order' do
            expect { send_request }.to_not change { purchase.reload.orders.count }
          end
        end
      end
    end
  end

  describe 'delete /purchases/:id/orders/:order_id' do
    let(:method) { :delete }
    let(:path) { "/purchases/#{id}/orders/#{order_id}" }
    let(:order_id) { rand_str }

    include_examples 'invalid id'

    context 'valid id' do
      let(:purchase) { FactoryGirl.create :purchase, :orders }
      let(:id) { purchase.id }

      shared_examples 'invalid order id' do
        context 'invalid order id' do
          include_examples 'not found'

          it 'does not remove order' do
            expect { send_request }.to_not change { purchase.reload.orders.count }
          end
        end
      end

      context 'pending' do
        before :each do
          expect(purchase).to be_pending
        end

        include_examples 'invalid order id'

        context 'valid order id' do
          let(:order) { purchase.orders.last }
          let(:order_id) { order.id }

          it 'removes the order' do
            expect { send_request }.to change { purchase.orders.count }.by(-1)
            expect_status(200)
            expect_response(PurchaseSerializer.new(purchase).to_json)
          end
        end
      end

      context 'committed' do
        before :each do
          expect { purchase.commit! }.to change { purchase.committed? }.to(true)
        end

        include_examples 'invalid order id'

        context 'valid order id' do
          let(:order) { purchase.orders.last }
          let(:order_id) { order.id }

          include_examples 'unprocessable'

          it 'removes the order' do
            expect { send_request }.to_not change { purchase.reload.orders.count }
          end
        end
      end
    end
  end

  describe 'put /purchases/:id/submit' do
    let(:method) { :put }
    let(:path) { "/purchases/#{id}/submit" }

    include_examples 'invalid id'

    context 'valid id' do
      let(:purchase) { FactoryGirl.create :purchase }
      let(:id) { purchase.id }

      before :each do
        purchase.add_or_update(item, amount, currency, qty)
      end

      it 'commits and fulfills the purchase' do
        expect { send_request }.to change { purchase.reload.committed? }.to(true)
        expect(purchase.orders.all?(&:fulfilled?)).to be_true
        expect(purchase.orders.any?(&:unmarked?)).to be_false
        expect_status(200)
        expect_response(PurchaseSerializer.new(purchase).to_json)
      end
    end
  end

  describe 'get /purchases/:id' do
    let(:method) { :get }
    let(:path) { "/purchases/#{id}" }

    include_examples 'invalid id'

    context 'valid id' do
      let(:purchase) { FactoryGirl.create :purchase }
      let(:id) { purchase.id }

      it 'returns the purchase' do
        send_request
        expect_status(200)
        expect_response(PurchaseSerializer.new(purchase).to_json)
      end
    end
  end

  describe 'put /purchases/:id/return' do
    let(:method) { :put }
    let(:path) { "/purchases/#{id}/return" }

    include_examples 'invalid id'

    context 'valid id' do
      let(:purchase) { FactoryGirl.create :purchase }
      let(:id) { purchase.id }

      before :each do
        purchase.add_or_update(item, amount, currency, qty)
      end

      context 'pending' do
        before :each do
          expect(purchase).to be_pending
        end

        include_examples 'unprocessable'

        it 'does nothing' do
          expect { send_request }.to_not change { purchase.reload.orders.all?(&:unmarked?) }
        end
      end

      context 'committed, fulfilled' do
        before :each do
          purchase.commit!
          purchase.pay!
          purchase.fulfill!
        end

        it 'reverses the purchase' do
          expect { send_request }.to change { purchase.reload.orders.all?(&:reversed?) }.to(true)
          expect(purchase.orders.any?(&:unmarked?)).to be_false
          expect_status(200)
          expect_response(PurchaseSerializer.new(purchase).to_json)
        end
      end
    end

    describe 'put /purchases/:id/orders/:order_id/return' do
      let(:method) { :put }
      let(:path) { "/purchases/#{id}/orders/#{order_id}/return" }
      let(:order_id) { rand_str }

      include_examples 'invalid id'

      context 'valid id' do
        let(:purchase) { FactoryGirl.create :purchase }
        let(:id) { purchase.id }

        before :each do
          purchase.add_or_update(item, amount, currency, qty)
        end

        context 'invalid order id' do
          include_examples 'not found'
        end

        context 'valid order id' do
          let(:order) { purchase.orders.last }
          let(:order_id) { order.id }

          context 'pending' do
            before :each do
              expect(purchase).to be_pending
            end

            include_examples 'unprocessable'

            it 'does nothing' do
              expect { send_request }.to_not change { purchase.reload.orders.all?(&:unmarked?) }
            end
          end

          context 'committed, fulfilled' do
            before :each do
              purchase.commit!
              purchase.pay!
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
