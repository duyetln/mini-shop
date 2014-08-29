module Inventory
  class StoreItemsController < ApplicationController
    def index
      @store_items = resource_class.all(sort: :desc)
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

    def edit
      @store_item = resource
      @prices = clipboard_prices
    end

    def update
      @store_item = update_resource(:store_item, :name, :price_id)
      redirect_to :back
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
