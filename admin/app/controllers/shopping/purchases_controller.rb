module Shopping
  class PurchasesController < ApplicationController
    def show
      @purchase = resource
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
