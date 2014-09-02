module Inventory
  class CurrenciesController < ApplicationController
    def create
      @currency = Currency.create(
        params.require(:currency).permit(:code, :sign)
      )
      flash[:success] = 'Currency created successfully' and go_back
    end
  end
end
