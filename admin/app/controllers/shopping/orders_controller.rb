module Shopping
  class OrdersController < ApplicationController
    def return
      @purchase = Purchase.find(params.require(:purchase_id))
      @purchase.return_order(id)
      render nothing: true
    end
  end
end
