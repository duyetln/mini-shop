module Inventory
  class StoreItemsController < ApplicationController
    def index
      @store_items = resource_class.all
      @physical_items = BackendClient::PhysicalItem.all
      @digital_items = BackendClient::DigitalItem.all
      @bundles = BackendClient::Bundle.all
      @prices = BackendClient::Price.all
    end

    def create
      @store_item = resource_class.create(
        scoped_params(:store_item, :name, :price_id).merge(
          Yajl::Parser.parse scoped_params(:store_item).require(:item)
        )
      )
      redirect_to :back
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
