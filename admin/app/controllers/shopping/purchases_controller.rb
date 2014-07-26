module Shopping
  class PurchasesController < ApplicationController
    def show
      @purchase = BackendClient::Purchase.find(params.require(:id))
      render nothing: true
    end

    def return
      @purchase = BackendClient::Purchase.find(params.require(:id))
      @purchase.return!
      render nothing: true
    end
  end
end
