require 'services/base'
require 'models/serializers/shopping'

module Services
  module Shopping
    class Purchases < Services::Base
      put '/:id' do
        process_request do
          purchase = Purchase.find(params[:id])
          purchase.committed? &&
            unprocessable! ||
            purchase.update_attributes!(purchase_params)
          respond_with(PurchaseSerializer.new(purchase))
        end
      end

      post '/:id/orders' do
        process_request do
          purchase = Purchase.find(params[:id])
          purchase.add_or_update(
            order_params[:item_type].classify.constantize.find(order_params[:item_id]),
            BigDecimal.new(order_params[:amount]),
            Currency.find(order_params[:currency_id]),
            order_params[:qty].to_i
          ) || unprocessable!
          respond_with(PurchaseSerializer.new(purchase))
        end
      end

      delete '/:id/orders/:order_id' do
        process_request do
          purchase = Purchase.find(params[:id])
          order = purchase.orders.find(params[:order_id])
          purchase.remove(order) || unprocessable!
          respond_with(PurchaseSerializer.new(purchase))
        end
      end

      put '/:id/submit' do
        process_request do
          purchase = Purchase.find(params[:id])
          purchase.commit!
          purchase.pay!
          purchase.fulfill!
          respond_with(PurchaseSerializer.new(purchase))
        end
      end

      get '/:id' do
        process_request do
          purchase = Purchase.find(params[:id])
          respond_with(PurchaseSerializer.new(purchase))
        end
      end

      put '/:id/return' do
        process_request do
          purchase = Purchase.find(params[:id])
          purchase.reverse! || unprocessable!
          respond_with(PurchaseSerializer.new(purchase))
        end
      end

      put '/:id/orders/:order_id/return' do
        process_request do
          purchase = Purchase.find(params[:id])
          order = purchase.orders.find(params[:order_id])
          purchase.reverse!(order) || unprocessable!
          respond_with(PurchaseSerializer.new(purchase))
        end
      end

      protected

      def purchase_params
        params[:purchase] || {}
      end

      def order_params
        params[:order] || {}
      end
    end
  end
end
