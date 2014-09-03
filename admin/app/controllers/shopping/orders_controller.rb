module Shopping
  class OrdersController < ApplicationController
    def return
      @purchase = Purchase.find(params.require(:purchase_id))
      @purchase.return_order(id)
      flash[:success] = 'Order refunded successfully' and go_back
    end
  end
end
