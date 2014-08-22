module Inventory
  class CurrenciesController < ApplicationController
    def index
      @currencies = BackendClient::Currency.all(pagination)
    end

    def create
      @currency =  resource_class.create(
        scoped_params(:currency, :code, :sign)
      )
      redirect_to :back
    end

    private

    def set_resource_class
      @resource_class = BackendClient::Currency
    end
  end
end
