module Inventory
  class PhysicalItemsController < ApplicationController
    def index
      @physical_items = resource_class.all
    end

    def create
      @physical_item = resource_class.create(
        scoped_params(:physical_item, :title, :description, :qty)
      )
      redirect_to :back
    end

    def update
      @physical_item = update_resource(:physical_item, :title, :description, :qty)
      redirect_to :back
    end

    def activate
      @physical_item = resource
      @physical_item.activate!
      redirect_to :back
    end

    def destroy
      @physical_item = resource
      @physical_item.delete!
      redirect_to :back
    end

    private

    def set_resource_class
      @resource_class = BackendClient::PhysicalItem
    end
  end
end
