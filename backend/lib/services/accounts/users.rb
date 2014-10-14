require 'services/base'

module Services
  module Accounts
    class Users < Services::Base
      get '/' do
        users = paginate(User).all
        respond_with(users.map do |user|
          UserSerializer.new(user)
        end)
      end

      get '/:id' do
        user = User.find_by_id(id) || User.find_by_email(id)
        not_found!(meta: 'Invalid id or email') if user.blank?
        respond_with(UserSerializer.new(user))
      end

      post '/' do
        user = User.new(user_params)
        user.save!
        respond_with(UserSerializer.new(user))
      end

      put '/:id' do
        user = User.find(id)
        user.update_attributes!(user_params)
        respond_with(UserSerializer.new(user))
      end

      post '/authenticate' do
        user = User.authenticate!(
          user_params[:email],
          user_params[:password]
        ) || unauthorized!(meta: 'Email or password is not valid')
        respond_with(UserSerializer.new(user))
      end

      put '/:uuid/confirm/:actv_code' do
        user = User.confirm!(params[:uuid], params[:actv_code])
        respond_with(UserSerializer.new(user))
      end

      get '/:id/ownerships' do
        user = User.find(id)
        ownerships = paginate(user.ownerships).all
        respond_with(ownerships.map do |ownership|
          OwnershipSerializer.new(ownership)
        end)
      end

      get '/:id/shipments' do
        user = User.find(id)
        shipments = paginate(user.shipments).all
        respond_with(shipments.map do |shipment|
          ShipmentSerializer.new(shipment)
        end)
      end

      get '/:id/coupons' do
        user = User.find(id)
        coupons = paginate(user.coupons).all
        respond_with(coupons.map do |coupon|
          CouponSerializer.new(coupon)
        end)
      end

      post '/:id/addresses' do
        user = User.find(id)
        user.addresses.create!(params[:address])
        respond_with(UserSerializer.new(user))
      end

      post '/:id/payment_methods' do
        user = User.find(id)
        user.payment_methods.create!(params[:payment_method])
        respond_with(UserSerializer.new(user))
      end

      get '/:id/transactions' do
        user = User.find(id)
        transactions = paginate(user.transactions).all
        respond_with(transactions.map do |transaction|
          DynamicSerializer.new(transaction)
        end)
      end

      get '/:id/purchases' do
        user = User.find(id)
        purchases = paginate(user.purchases).all
        respond_with(purchases.map do |purchase|
          PurchaseSerializer.new(purchase)
        end)
      end

      post '/:id/purchases' do
        user = User.find(id)
        purchase = user.purchases.create!(params[:purchase])
        respond_with(PurchaseSerializer.new(purchase))
      end

      protected

      def user_params
        params[:user] || {}
      end
    end
  end
end
