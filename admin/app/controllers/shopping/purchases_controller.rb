module Shopping
  class PurchasesController < ApplicationController
    def show
      @purchase         = resource
      @payment_method   = @purchase.payment_method
      @billing_address  = @purchase.billing_address
      @shipping_address = @purchase.shipping_address
      @orders           = @purchase.orders
      @payment          = @purchase.payment
      render nothing: true
    end

    def return
      @purchase = resource
      @purchase.return!
      render nothing: true
    end

    private

    def set_resource_class
      @resource_class = BackendClient::Purchase
    end
  end
end
