module Inventory
  class CurrenciesController < ApplicationController
    def index
      @currencies = BackendClient::Currency.all(pagination)
      render nothing: true
    end

    def create
      params.require(:currencies).each do |currency|
        BackendClient::Currency.create(currency.permit(:code, :sign))
      end
      render nothing: true
    end
  end
end
