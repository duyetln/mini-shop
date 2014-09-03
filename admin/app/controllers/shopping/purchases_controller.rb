module Shopping
  class PurchasesController < ApplicationController
    def show
      @purchase = Purchase.find(id)
      @payment_method = @purchase.payment_method
      @billing_address = @purchase.billing_address
      @shipping_address = @purchase.shipping_address
      @orders = @purchase.orders
      @payment = @purchase.payment
      @user = @purchase.user
    end

    def return
      @purchase = Purchase.find(id)
      @purchase.return!
      flash[:success] = 'Purchase refunded successfuly' and go_back
    end
  end
end
