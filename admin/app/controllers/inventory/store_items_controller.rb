module Inventory
  class StoreItemsController < ApplicationController
    def index
      @store_items = resource_class.all(pagination)
      @bundles = clipboard_bundles
      @physical_items = clipboard_physical_items
      @digital_items = clipboard_digital_items
      @prices = clipboard_prices
    end

    def create
      @store_item = resource_class.create(
        scoped_params(:store_item, :name, :price_id).merge(
          scoped_params(:items).find { |item| !!item[:selected] }.permit(:item_type, :item_id)
        )
      )
      redirect_to :back
    end

    def show
      @store_item = resource
      @item       = @store_item.item
      @price      = @store_item.price
      render nothing: true
    end

    def edit
      @store_item = resource
      render nothing: true
    end

    def update
      @store_item = update_resource(:store_item, :name, :price_id)
      render nothing: true
    end

    def destroy
      @store_item = resource
      @store_item.delete!
      redirect_to :back
    end

    private

    def set_resource_class
      @resource_class = BackendClient::StoreItem
    end
  end
end
