require 'services/spec_setup'
require 'spec/services/shared/errors'

describe Services::Accounts::Users do
  let :user do
    User.find FactoryGirl.create(:user, password: password).id
  end

  let(:password) { rand_str }
  let(:email) { user.email }
  let(:uuid) { user.uuid }
  let(:actv_code) { user.actv_code }
  let(:id) { user.id }

  describe 'get /users/:id' do
    let(:method) { :get }
    let(:path) { "/users/#{id}" }

    context 'valid id' do
      it 'returns the user' do
        send_request
        expect_status(200)
        expect_response(UserSerializer.new(user).to_json)
      end
    end

    context 'invalid id' do
      let(:id) { rand_str }

      include_examples 'not found'
    end
  end

  describe 'post /users' do
    let(:method) { :post }
    let(:path) { '/users' }
    let(:user) { FactoryGirl.build :user }

    context 'valid parameters' do
      let(:params) { { user: user.attributes } }

      it 'creates a new user' do
        expect { send_request }.to change { User.count }.by(1)
        expect_status(200)
        expect_response(UserSerializer.new(User.last).to_json)
      end
    end

    context 'invalid parameters' do
      let(:params) { {} }

      include_examples 'bad request'
    end
  end

  describe 'post /users/authenticate' do
    let(:method) { :post }
    let(:path) { '/users/authenticate' }
    let(:params) { { email: input_email, password: input_password } }
    let(:input_email) { email }
    let(:input_password) { password }

    context 'unconfirmed' do
      before :each do
        expect(user).to_not be_confirmed
      end

      include_examples 'not found'
    end

    context 'confirmed' do
      before :each do
        user.confirm!
      end

      context 'wrong email' do
        let(:input_email) { rand_str }

        include_examples 'not found'
      end

      context 'wrong password' do
        let(:input_password) { password + rand_str }

        include_examples 'unauthorized'
      end

      context 'correct credentials' do
        it 'authenticates the user' do
          send_request
          expect_status(200)
          expect_response(UserSerializer.new(user).to_json)
        end
      end
    end
  end

  describe 'put /users/:id' do
    let(:method) { :put }
    let(:path) { "/users/#{id}" }
    let(:params) { { user: user.attributes } }

    context 'invalid id' do
      let(:id) { rand_str }

      include_examples 'not found'
    end

    context 'valid id' do
      context 'invalid parameters' do
        let(:params) { { user: { first_name: nil } } }

        include_examples 'bad request'
      end

      context 'valid parameters' do
        it 'updates the user' do
          send_request
          expect_status(200)
          expect_response(UserSerializer.new(user).to_json)
        end
      end
    end
  end

  describe 'put /users/:uuid/confirm/:actv_code' do
    let(:method) { :put }
    let(:path) { "/users/#{uuid}/confirm/#{actv_code}" }

    context 'invalid uuid' do
      let(:uuid) { rand_str }

      include_examples 'not found'
    end

    context 'invalid activation code' do
      let(:actv_code) { rand_str }

      include_examples 'not found'
    end

    context 'confirmed' do
      before :each do
        user.confirm!
      end

      include_examples 'not found'
    end

    context 'unconfirmed, valid uuid, valid activation code' do
      before :each do
        expect(user).to_not be_confirmed
      end

      it 'confirms and returns the user' do
        expect { send_request }.to change { user.reload.confirmed? }.to(true)
        expect_status(200)
        expect_response(UserSerializer.new(user).to_json)
      end
    end
  end

  describe 'get /users/:id/addresses' do
    let(:method) { :get }
    let(:path) { "/users/#{id}/addresses" }

    context 'invalid id' do
      let(:id) { rand_str }

      include_examples 'not found'
    end

    context 'valid id' do
      it 'returns the addresses' do
        send_request
        expect_status(200)
        expect_response(user.addresses.map do |address|
          AddressSerializer.new(address)
        end.to_json)
      end
    end
  end

  describe 'post /users/:id/addresses' do
    let(:method) { :post }
    let(:path) { "/users/#{id}/addresses" }

    context 'invalid id' do
      let(:id) { rand_str }

      include_examples 'not found'
    end

    context 'valid id' do
      context 'invalid parameters' do
        let(:params) { {} }

        include_examples 'bad request'
      end

      context 'valid parameters' do
        let :params do
          { address: FactoryGirl.build(:address).attributes.except('user_id') }
        end

        it 'creates a new address' do
          expect { send_request }.to change { user.addresses.count }.by(1)
          expect_status(200)
          expect_response(AddressSerializer.new(user.addresses.last).to_json)
        end
      end
    end
  end

  describe 'put /users/:id/addresses/:address_id' do
    let(:method) { :put }
    let(:path) { "/users/#{id}/addresses/#{address_id}" }
    let(:address) { Address.find FactoryGirl.create(:address, user: user).id }
    let(:address_id) { address.id }
    let(:params) { { address: address.attributes } }

    context 'invalid id' do
      let(:id) { rand_str }

      include_examples 'not found'
    end

    context 'valid id' do
      context 'invalid address id' do
        let(:address_id) { rand_str }

        include_examples 'not found'
      end

      context 'valid address id' do
        context 'invalid parameters' do
          let(:params) { { address: { line1: nil } } }

          include_examples 'bad request'
        end

        context 'valid parameters' do
          it 'updates the address' do
            send_request
            expect_status(200)
            expect_response(AddressSerializer.new(address).to_json)
          end
        end
      end
    end
  end

  describe 'get /users/:id/payment_methods' do
    let(:method) { :get }
    let(:path) { "/users/#{id}/payment_methods" }

    context 'invalid id' do
      let(:id) { rand_str }

      include_examples 'not found'
    end

    context 'valid id' do
      it 'returns the payment methods' do
        send_request
        expect_status(200)
        expect_response(user.payment_methods.map do |payment_method|
          PaymentMethodSerializer.new(payment_method)
        end.to_json)
      end
    end
  end

  describe 'post /users/:id/payment_methods' do
    let(:method) { :post }
    let(:path) { "/users/#{id}/payment_methods" }

    context 'invalid id' do
      let(:id) { rand_str }

      include_examples 'not found'
    end

    context 'valid id' do
      context 'invalid parameters' do
        let(:params) { {} }

        include_examples 'bad request'
      end

      context 'valid parameters' do
        let :params do
          { payment_method: FactoryGirl.build(:payment_method).attributes.except('user_id') }
        end

        it 'creates a new payment method' do
          expect { send_request }.to change { user.payment_methods.count }.by(1)
          expect_status(200)
          expect_response(PaymentMethodSerializer.new(user.payment_methods.last).to_json)
        end
      end
    end
  end

  describe 'put /users/:id/payment_methods/:payment_method_id' do
    let(:method) { :put }
    let(:path) { "/users/#{id}/payment_methods/#{payment_method_id}" }
    let(:payment_method) { PaymentMethod.find FactoryGirl.create(:payment_method, user: user).id }
    let(:payment_method_id) { payment_method.id }
    let(:params) { { payment_method: payment_method.attributes } }

    context 'invalid id' do
      let(:id) { rand_str }

      include_examples 'not found'
    end

    context 'valid id' do
      context 'invalid payment method id' do
        let(:payment_method_id) { rand_str }

        include_examples 'not found'
      end

      context 'valid payment method id' do
        context 'invalid parameters' do
          let(:params) { { payment_method: { balance: nil } } }

          include_examples 'bad request'
        end

        context 'valid parameters' do
          it 'updates the payment method' do
            send_request
            expect_status(200)
            expect_response(PaymentMethodSerializer.new(payment_method).to_json)
          end
        end
      end
    end
  end

  describe 'get /users/:id/purchases' do
    let(:method) { :get }
    let(:path) { "/users/#{id}/purchases" }

    context 'invalid id' do
      let(:id) { rand_str }

      include_examples 'not found'
    end

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

    context 'invalid id' do
      let(:id) { rand_str }

      include_examples 'not found'
    end

    context 'valid id' do
      it 'returns the orders' do
        send_request
        expect_status(200)
        orders = user.purchases.map(&:orders).flatten
        expect_response(orders.map do |order|
          OrderSerializer.new(order)
        end.to_json)
      end
    end
  end

  describe 'get /users/:id/ownerships' do
    let(:method) { :get }
    let(:path) { "/users/#{id}/ownerships" }

    context 'invalid id' do
      let(:id) { rand_str }

      include_examples 'not found'
    end

    context 'valid id' do
      it 'returns the ownerships' do
        send_request
        expect_status(200)
        expect_response(user.ownerships.map do |ownership|
          OwnershipSerializer.new(ownership)
        end.to_json)
      end
    end
  end

  describe 'get /users/:id/shipments' do
    let(:method) { :get }
    let(:path) { "/users/#{id}/shipments" }

    context 'invalid id' do
      let(:id) { rand_str }

      include_examples 'not found'
    end

    context 'valid id' do
      it 'returns the shipments' do
        send_request
        expect_status(200)
        expect_response(user.shipments.map do |shipment|
          ShipmentSerializer.new(shipment)
        end.to_json)
      end
    end
  end
end
