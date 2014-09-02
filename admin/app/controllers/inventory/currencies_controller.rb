module Inventory
  class CurrenciesController < ApplicationController
    def create
      @currency = Currency.create(
        params.require(:currency).permit(:code, :sign)
      )
      go_back
    end
  end
end
