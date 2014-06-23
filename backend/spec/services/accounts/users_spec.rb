require 'services/spec_setup'
require 'spec/services/shared/errors'

describe Services::Accounts::Users do
  let(:user) { FactoryGirl.create :user, password: password }
  let(:password) { rand_str }
  let(:email) { user.email }
  let(:uuid) { user.uuid }
  let(:actv_code) { user.actv_code }
  let(:id) { user.id }

  describe 'get /users/:id' do
    let(:method) { :get }
    let(:path) { "/users/#{id}" }

    include_examples 'invalid id'

    context 'valid id' do
      it 'returns the user' do
        send_request
        expect_status(200)
        expect_response(UserSerializer.new(user).to_json)
      end
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

      it 'does not create new user' do
        expect { send_request }.to_not change { User.count }
      end
    end
  end

  describe 'post /users/authenticate' do
    let(:method) { :post }
    let(:path) { '/users/authenticate' }
    let(:params) { { user: { email: input_email, password: input_password } } }
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
        expect { user.confirm! }.to change { user.confirmed? }.to(true)
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

    include_examples 'invalid id'

    context 'valid id' do
      context 'invalid parameters' do
        let(:params) { { user: { first_name: nil } } }

        include_examples 'bad request'

        it 'does not update the user' do
          expect { send_request }.to_not change { user.reload.attributes }
        end
      end

      context 'valid parameters' do
        let(:params) { { user: { first_name: rand_str } } }

        it 'updates the user' do
          expect { send_request }.to change { user.reload.attributes }
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

      it 'does not update the user' do
        expect { send_request }.to_not change { user.reload.attributes }
      end
    end

    context 'invalid activation code' do
      let(:actv_code) { rand_str }

      include_examples 'not found'

      it 'does not update the user' do
        expect { send_request }.to_not change { user.reload.attributes }
      end
    end

    context 'confirmed' do
      before :each do
        expect { user.confirm! }.to change { user.confirmed? }.to(true)
      end

      include_examples 'not found'

      it 'does not update the user' do
        expect { send_request }.to_not change { user.reload.attributes }
      end
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

  describe 'get /users/:id/ownerships' do
    let(:method) { :get }
    let(:path) { "/users/#{id}/ownerships" }

    include_examples 'invalid id'

    context 'valid id' do
      before :each do
        FactoryGirl.create :ownership, user: user
      end

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

    include_examples 'invalid id'

    context 'valid id' do
      before :each do
        FactoryGirl.create :shipment, user: user
      end

      it 'returns the shipments' do
        send_request
        expect_status(200)
        expect_response(user.shipments.map do |shipment|
          ShipmentSerializer.new(shipment)
        end.to_json)
      end
    end
  end

  describe 'get /users/:id/addresses' do
    let(:method) { :get }
    let(:path) { "/users/#{id}/addresses" }

    include_examples 'invalid id'

    context 'valid id' do
      before :each do
        FactoryGirl.create :address, user: user
      end

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

    include_examples 'invalid id'

    context 'valid id' do
      context 'invalid parameters' do
        let(:params) { {} }

        include_examples 'bad request'
      end

      context 'valid parameters' do
        let :params do
          { address: FactoryGirl.build(:address).attributes }
        end

        it 'creates a new address' do
          expect { send_request }.to change { user.addresses.count }.by(1)
          expect_status(200)
          expect_response(AddressSerializer.new(user.addresses.last).to_json)
        end
      end
    end
  end

  describe 'get /users/:id/orders' do
    let(:method) { :get }
    let(:path) { "/users/#{id}/orders" }

    include_examples 'invalid id'

    context 'valid id' do
      before :each do
        FactoryGirl.create :order, purchase: FactoryGirl.create(:purchase, user: user)
      end

      it 'returns the orders' do
        send_request
        expect_status(200)
        expect_response(user.purchases.map(&:orders).flatten.map do |order|
          OrderSerializer.new(order)
        end.to_json)
      end
    end
  end

  describe 'get /users/:id/payment_methods' do
    let(:method) { :get }
    let(:path) { "/users/#{id}/payment_methods" }

    include_examples 'invalid id'

    context 'valid id' do
      before :each do
        FactoryGirl.create :payment_method, user: user
      end

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

    include_examples 'invalid id'

    context 'valid id' do
      context 'invalid parameters' do
        let(:params) { {} }

        include_examples 'bad request'
      end

      context 'valid parameters' do
        let :params do
          { payment_method: FactoryGirl.build(:payment_method).attributes }
        end

        it 'creates a new payment method' do
          expect { send_request }.to change { user.payment_methods.count }.by(1)
          expect_status(200)
          expect_response(PaymentMethodSerializer.new(user.payment_methods.last).to_json)
        end
      end
    end
  end

  describe 'get /users/:id/purchases' do
    let(:method) { :get }
    let(:path) { "/users/#{id}/purchases" }

    include_examples 'invalid id'

    context 'valid id' do
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
end
