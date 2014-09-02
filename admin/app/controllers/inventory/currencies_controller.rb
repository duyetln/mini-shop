module Inventory
  class CurrenciesController < ApplicationController
    def create
      @currency = Currency.create(
        params.require(:currency).permit(:code, :sign)
      )
      redirect_to :back
    end
  end
end
