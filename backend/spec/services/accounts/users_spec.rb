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

    include_examples 'invalid id'

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
end
