module Shopping
  class OrdersController < ApplicationController
    def return
      @purchase = BackendClient::Purchase.find(scoped_params(:purchase_id))
      @purchase.return_order(id)
      render nothing: true
    end
  end
end
