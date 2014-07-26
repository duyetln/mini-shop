module Shopping
  class OrdersController < ApplicationController
    def return
      @purchase = BackendClient::Purchase.find(params.require(:purchase_id))
      @purchase.return_order(params.require(:id))
      render nothing: true
    end
  end
end
