require 'services/base'
require 'models/serializers/accounts'

module Services
  module Accounts
    class Users < Services::Base
      get '/users/:id' do
        process_request do
          user = User.find(params[:id])
          respond_with(UserSerializer.new(user))
        end
      end

      post '/users' do
        process_request do
          user = User.new(user_params)
          user.save!
          respond_with(UserSerializer.new(user))
        end
      end

      post '/users/authenticate' do
        process_request do
          user = User.authenticate!(
            user_params[:email],
            user_params[:password]
          ) || unauthorized!
          respond_with(UserSerializer.new(user))
        end
      end

      put '/users/:id' do
        process_request do
          user = User.find(params[:id])
          user.update_attributes!(user_params)
          respond_with(UserSerializer.new(user))
        end
      end

      put '/users/:uuid/confirm/:actv_code' do
        process_request do
          user = User.confirm!(params[:uuid], params[:actv_code])
          respond_with(UserSerializer.new(user))
        end
      end

      get '/users/:id/ownerships' do
        process_request do
          user = User.find(params[:id])
          respond_with(user.ownerships.map do |ownership|
            OwnershipSerializer.new(ownership)
          end)
        end
      end

      get '/users/:id/shipments' do
        process_request do
          user = User.find(params[:id])
          respond_with(user.shipments.map do |shipment|
            ShipmentSerializer.new(shipment)
          end)
        end
      end

      get '/users/:id/addresses' do
        process_request do
          addresses = User.find(params[:id]).addresses
          respond_with(addresses.map do |address|
            AddressSerializer.new(address)
          end)
        end
      end

      post '/users/:id/addresses' do
        process_request do
          address = User.find(params[:id]).addresses.create!(params[:address])
          respond_with(AddressSerializer.new(address))
        end
      end

      get '/users/:id/orders' do
        process_request do
          orders = User.find(params[:id]).purchases.map(&:orders).flatten
          respond_with(orders.map do |order|
            OrderSerializer.new(order)
          end)
        end
      end

      get '/users/:id/payment_methods' do
        process_request do
          payment_methods = User.find(params[:id]).payment_methods
          respond_with(payment_methods.map do |payment_method|
            PaymentMethodSerializer.new(payment_method)
          end)
        end
      end

      post '/users/:id/payment_methods' do
        process_request do
          payment_method = User.find(params[:id]).payment_methods.create!(params[:payment_method])
          respond_with(PaymentMethodSerializer.new(payment_method))
        end
      end

      get '/users/:id/purchases' do
        process_request do
          purchases = User.find(params[:id]).purchases
          respond_with(purchases.map do |purchase|
            PurchaseSerializer.new(purchase)
          end)
        end
      end

      post '/users/:id/purchases' do
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
