require 'services/spec_setup'

describe Services::Accounts::Users do
  let(:user) { FactoryGirl.create :user, password: password }
  let(:password) { rand_str }
  let(:email) { user.email }
  let(:uuid) { user.uuid }
  let(:actv_code) { user.actv_code }
  let(:id) { user.id }

  describe 'get /' do
    let(:method) { :get }
    let(:path) { '/' }

    before :each do
      user.save!
    end

    context 'pagination' do
      let(:scope) { User }
      let(:serializer) { UserSerializer }

      include_examples 'pagination'
    end
  end

  describe 'get /:id' do
    let(:method) { :get }
    let(:path) { "/#{id}" }

    include_examples 'invalid id'

    context 'valid id' do
      it 'returns the user' do
        send_request
        expect_status(200)
        expect_response(UserSerializer.new(user).to_json)
      end
    end

    context 'valid email' do
      let(:id) { email }

      it 'returns the user' do
        send_request
        expect_status(200)
        expect_response(UserSerializer.new(user).to_json)
      end
    end
  end

  describe 'post /' do
    let(:method) { :post }
    let(:path) { '/' }
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

  describe 'put /:id' do
    let(:method) { :put }
    let(:path) { "/#{id}" }

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

  describe 'post /authenticate' do
    let(:method) { :post }
    let(:path) { '/authenticate' }
    let(:params) { { user: { email: input_email, password: input_password } } }
    let(:input_email) { email }
    let(:input_password) { password }

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

  describe 'put /:uuid/confirm/:actv_code' do
    let(:method) { :put }
    let!(:path) { "/#{uuid}/confirm/#{actv_code}" }

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

  describe 'get /:id/ownerships' do
    let(:method) { :get }
    let(:path) { "/#{id}/ownerships" }

    include_examples 'invalid id'

    context 'valid id' do
      before :each do
        FactoryGirl.create :ownership, user: user
      end

      context 'pagination' do
        let(:scope) { user.ownerships }
        let(:serializer) { OwnershipSerializer }

        include_examples 'pagination'
      end
    end
  end

  describe 'get /:id/shipments' do
    let(:method) { :get }
    let(:path) { "/#{id}/shipments" }

    include_examples 'invalid id'

    context 'valid id' do
      before :each do
        FactoryGirl.create :shipment, user: user
      end

      context 'pagination' do
        let(:scope) { user.shipments }
        let(:serializer) { ShipmentSerializer }

        include_examples 'pagination'
      end
    end
  end

  describe 'get /:id/coupons' do
    let(:method) { :get }
    let(:path) { "/#{id}/coupons" }

    include_examples 'invalid id'

    context 'valid id' do
      before :each do
        FactoryGirl.create(:coupon).used_by!(user)
      end

      context 'pagination' do
        let(:scope) { user.coupons }
        let(:serializer) { CouponSerializer }

        include_examples 'pagination'
      end
    end
  end

  describe 'post /:id/addresses' do
    let(:method) { :post }
    let(:path) { "/#{id}/addresses" }

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
          expect_response(UserSerializer.new(user).to_json)
        end
      end
    end
  end

  describe 'post /:id/payment_methods' do
    let(:method) { :post }
    let(:path) { "/#{id}/payment_methods" }

    include_examples 'invalid id'

    context 'valid id' do
      context 'invalid parameters' do
        let(:params) { {} }

        include_examples 'bad request'
      end

      context 'valid parameters' do
        let(:address) { FactoryGirl.create :address, user: user }
        let :params do
          {
            payment_method: FactoryGirl.build(:payment_method, billing_address: address).attributes
          }
        end

        it 'creates a new payment method' do
          expect { send_request }.to change { user.payment_methods.count }.by(1)
          expect_status(200)
          expect_response(UserSerializer.new(user).to_json)
        end
      end
    end
  end

  describe 'get /:id/transactions' do
    let(:method) { :get }
    let(:path) { "/#{id}/transactions" }

    include_examples 'invalid id'

    context 'valid id' do
      before :each do
        FactoryGirl.create :payment_transaction, user: user
      end

      context 'pagination' do
        let(:scope) { user.transactions }
        let(:serializer) { DynamicSerializer }

        include_examples 'pagination'
      end
    end
  end

  describe 'get /:id/purchases' do
    let(:method) { :get }
    let(:path) { "/#{id}/purchases" }

    include_examples 'invalid id'

    context 'valid id' do
      before :each do
        FactoryGirl.create :purchase, user: user
      end

      context 'pagination' do
        let(:scope) { user.purchases }
        let(:serializer) { PurchaseSerializer }

        include_examples 'pagination'
      end
    end
  end

  describe 'post /:id/purchases' do
    let(:method) { :post }
    let(:path) { "/#{id}/purchases" }

    include_examples 'invalid id'

    context 'valid id' do
      context 'valid parameters' do
        let(:address) { FactoryGirl.create :address, user: user }
        let(:params) { { purchase: { shipping_address_id: address.id } } }

        it 'creates new purchase' do
          expect { send_request }.to change { user.purchases.count }.by(1)
          expect_status(200)
          expect_response(PurchaseSerializer.new(user.purchases.last).to_json)
        end

        it 'sets the attributes' do
          send_request
          expect(user.purchases.last.shipping_address).to eq(address)
          expect(user.purchases.last).to be_pending
        end
      end
    end
  end
end
