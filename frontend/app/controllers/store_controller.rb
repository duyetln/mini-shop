class StoreController < ApplicationController
  def show
    @usd = Currency.all.find { |currency| currency.code == 'USD' }
    @store_items = StoreItem.all
  end
end
