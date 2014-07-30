require 'services/base'

module Services
  module Shopping
    class Purchases < Services::Base
      get '/:id' do
        purchase = Purchase.find(id)
        respond_with(PurchaseSerializer.new(purchase))
      end

      put '/:id' do
        purchase = Purchase.find(id)
        purchase.committed? &&
          unprocessable!(
            message: 'Unable to update purchase',
            meta: 'The purchase is not modifiable currently') ||
          purchase.update_attributes!(purchase_params)
        respond_with(PurchaseSerializer.new(purchase))
      end

      post '/:id/orders' do
        purchase = Purchase.find(id)
        purchase.add_or_update(
          constantize!(order_params[:item_type]).find(order_params[:item_id]),
          BigDecimal.new(order_params[:amount]),
          Currency.find(order_params[:currency_id]),
          order_params[:qty].to_i
        ) || unprocessable!(
          message: 'Unable to add or update order',
          meta: 'The purchase is not modifiable currently')
        respond_with(PurchaseSerializer.new(purchase))
      end

      delete '/:id/orders/:order_id' do
        purchase = Purchase.find(id)
        order = purchase.orders.find(params[:order_id])
        purchase.remove(order) || unprocessable!(
          message: 'Unable to remove order',
          meta: 'The purchase is not modifiable currently')
        respond_with(PurchaseSerializer.new(purchase))
      end

      put '/:id/submit' do
        purchase = Purchase.find(id)
        purchase.commit!
        purchase.pay!
        purchase.fulfill!
        respond_with(PurchaseSerializer.new(purchase))
      end

      put '/:id/return' do
        purchase = Purchase.find(id)
        purchase.reverse! || unprocessable!(
          message: 'Unable to return purchase',
          meta: 'The purchase is not submitted or not returnable')
        respond_with(PurchaseSerializer.new(purchase))
      end

      put '/:id/orders/:order_id/return' do
        purchase = Purchase.find(id)
        order = purchase.orders.find(params[:order_id])
        purchase.reverse!(order) || unprocessable!(
          message: 'Unable to return order',
          meta: 'The purchase is not submitted or not returnable')
        respond_with(PurchaseSerializer.new(purchase))
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
