require 'services/base'
require 'services/serializers/shopping'

module Services
  module Shopping
    class Purchases < Services::Base
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
          purchase = current_purchase.first_or_create!(purchase_params)
          respond_with(PurchaseSerializer.new(purchase))
        end
      end

      get '/users/:id/purchases/current' do
        process_request do
          purchase = current_purchase.first!
          respond_with(PurchaseSerializer.new(purchase))
        end
      end

      put '/users/:id/purchases/current' do
        process_request do
          purchase = current_purchase.first!
          purchase.update_attributes!(purchase_params)
          respond_with(PurchaseSerializer.new(purchase))
        end
      end

      post '/users/:id/purchases/current/orders' do
        process_request do
          purchase = current_purchase.first!
          purchase.add_or_update(
            order_params[:item_type].classify.constantize.find(order_params[:item_id]),
            BigDecimal.new(order_params[:amount]),
            Currency.find(order_params[:currency_id]),
            order_params[:qty].to_i
          )
          respond_with(PurchaseSerializer.new(purchase))
        end
      end

      delete '/users/:id/purchases/current/orders/:order_id' do
        process_request do
          purchase = current_purchase.first!
          order = purchase.orders.find(params[:order_id])
          purchase.remove(order)
          respond_with(PurchaseSerializer.new(purchase))
        end
      end

      put '/users/:id/purchases/current/submit' do
        process_request do
          purchase = current_purchase.first!
          purchase.commit!
          purchase.pay!
          purchase.fulfill!
          respond_with(PurchaseSerializer.new(purchase))
        end
      end

      get '/users/:id/purchases/:purchase_id' do
        process_request do
          purchase = load_purchase!
          respond_with(PurchaseSerializer.new(purchase))
        end
      end

      put '/users/:id/purchases/:purchase_id/return' do
        process_request do
          purchase = load_purchase!
          purchase.reverse!
          respond_with(PurchaseSerializer.new(purchase))
        end
      end

      put '/users/:id/purchases/:purchase_id/orders/:order_id/return' do
        process_request do
          purchase = load_purchase!
          order = purchase.orders.find(params[:order_id])
          purchase.reverse!(order)
          respond_with(PurchaseSerializer.new(purchase))
        end
      end

      protected

      def current_purchase
        Purchase.current(User.find(params[:id]))
      end

      def load_purchase!
        User.find(params[:id]).purchases.find(params[:purchase_id])
      end

      def purchase_params
        params[:purchase] || {}
      end

      def order_params
        params[:order] || {}
      end
    end
  end
end
