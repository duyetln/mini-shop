module Inventory
  class StoreItemsController < ApplicationController
    def index
      @store_items = resource_class.all(pagination)
    end

    def create
      @store_item = resource.create(
        scoped_params(:store_item, :name, :item_type, :item_id, :price_id)
      )
      render nothing: true
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
