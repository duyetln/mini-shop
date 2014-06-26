require 'services/base'

module Services
  module Accounts
    class Users < Services::Base
      get '/:id' do
        process_request do
          user = User.find(params[:id])
          respond_with(UserSerializer.new(user))
        end
      end

      post '/' do
        process_request do
          user = User.new(user_params)
          user.save!
          respond_with(UserSerializer.new(user))
        end
      end

      post '/authenticate' do
        process_request do
          user = User.authenticate!(
            user_params[:email],
            user_params[:password]
          ) || unauthorized!
          respond_with(UserSerializer.new(user))
        end
      end

      put '/:id' do
        process_request do
          user = User.find(params[:id])
          user.update_attributes!(user_params)
          respond_with(UserSerializer.new(user))
        end
      end

      put '/:uuid/confirm/:actv_code' do
        process_request do
          user = User.confirm!(params[:uuid], params[:actv_code])
          respond_with(UserSerializer.new(user))
        end
      end

      get '/:id/ownerships' do
        process_request do
          user = User.find(params[:id])
          respond_with(user.ownerships.map do |ownership|
            OwnershipSerializer.new(ownership)
          end)
        end
      end

      get '/:id/shipments' do
        process_request do
          user = User.find(params[:id])
          respond_with(user.shipments.map do |shipment|
            ShipmentSerializer.new(shipment)
          end)
        end
      end

      post '/:id/addresses' do
        process_request do
          user = User.find(params[:id])
          user.addresses.create!(params[:address])
          respond_with(UserSerializer.new(user))
        end
      end

      post '/:id/payment_methods' do
        process_request do
          user = User.find(params[:id])
          user.payment_methods.create!(params[:payment_method])
          respond_with(UserSerializer.new(user))
        end
      end

      get '/:id/orders' do
        process_request do
          orders = User.find(params[:id]).purchases.map(&:orders).flatten
          respond_with(orders.map do |order|
            OrderSerializer.new(order)
          end)
        end
      end

      get '/:id/purchases' do
        process_request do
          purchases = User.find(params[:id]).purchases
          respond_with(purchases.map do |purchase|
            PurchaseSerializer.new(purchase)
          end)
        end
      end

      post '/:id/purchases' do
        process_request do
          purchase = User.find(params[:id]).purchases.create!(params[:purchase])
          respond_with(PurchaseSerializer.new(purchase))
        end
      end

      protected

      def user_params
        params[:user] || {}
      end
    end
  end
end
