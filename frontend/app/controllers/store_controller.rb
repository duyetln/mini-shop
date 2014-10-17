class StoreController < ApplicationController
  def show
    @store_items = StoreItem.all
  end
end
