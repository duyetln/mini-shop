module Inventory
  class StoreItemsController < ApplicationController
    def index
      @store_items = resource_class.all(pagination)
      render nothing: true
    end

    def create
      @store_item = resource.create(
        scoped_params(:store_item, :name, :item_type, :item_id, :price_id)
      )
      render nothing: true
    end

    def show
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
      render nothing: true
    end

    private

    def set_resource_class
      @resource_class = BackendClient::StoreItem
    end
  end
end
