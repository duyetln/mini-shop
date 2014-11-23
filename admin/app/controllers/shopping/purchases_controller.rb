module Shopping
  class PurchasesController < ApplicationController
    def return
      @purchase = Purchase.find(id)
      @purchase.return!
      flash[:success] = 'Purchase refunded successfuly' and go_back
    end
  end
end
