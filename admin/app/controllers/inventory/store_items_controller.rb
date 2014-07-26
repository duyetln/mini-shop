module Inventory
  class StoreItemsController < ApplicationController
    def index
      @store_items = BackendClient::StoreItem.all(pagination)
      render nothing: true
    end

    def create
      @store_item = BackendClient::StoreItem.create(params.require(:store_item).permit(:name, :item_type, :item_id, :price_id))
      render nothing: true
    end

    def show
      @store_item = BackendClient::StoreItem.find(params.require(:id))
      render nothing: true
    end

    def update
      @store_item = BackendClient::StoreItem.find(params.require(:id))
      @store_item.merge!(params.require(:store_item).permit(:name, :price_id))
      @store_item.update!(:name, :price_id)
      render nothing: true
    end

    def destroy
      @store_item = BackendClient::StoreItem.find(params.require(:id))
      @store_item.delete!
      render nothing: true
    end
  end
end
