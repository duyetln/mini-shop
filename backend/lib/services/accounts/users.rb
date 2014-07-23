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
        user = User.find(id)
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
        ) || unauthorized!
        respond_with(UserSerializer.new(user))
      end

      put '/:uuid/confirm/:actv_code' do
        user = User.confirm!(params[:uuid], params[:actv_code])
        respond_with(UserSerializer.new(user))
      end

      get '/:id/ownerships' do
        check_id!
        ownerships = Ownership.for_user(id)
        respond_with(ownerships.map do |ownership|
          OwnershipSerializer.new(ownership)
        end)
      end

      get '/:id/shipments' do
        check_id!
        shipments = Shipment.for_user(id)
        respond_with(shipments.map do |shipment|
          ShipmentSerializer.new(shipment)
        end)
      end

      get '/:id/coupons' do
        check_id!
        coupons = Coupon.for_user(id)
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
        check_id!
        transactions = Transaction.for_user(id)
        respond_with(transactions.map do |transaction|
          TransactionSerializer.new(transaction)
        end)
      end

      get '/:id/orders' do
        check_id!
        orders = Order.for_user(id)
        respond_with(orders.map do |order|
          OrderSerializer.new(order)
        end)
      end

      get '/:id/purchases' do
        check_id!
        purchases = Purchase.for_user(id)
        respond_with(purchases.map do |purchase|
          PurchaseSerializer.new(purchase)
        end)
      end

      post '/:id/purchases' do
        check_id!
        purchase = Purchase.where(user_id: id).create!(params[:purchase])
        respond_with(PurchaseSerializer.new(purchase))
      end

      protected

      def check_id!
        User.exists?(id) || not_found!
      end

      def user_params
        params[:user] || {}
      end
    end
  end
end
