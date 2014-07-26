module Inventory
  class PhysicalItemsController < ApplicationController
    def index
      @physical_items = resource_class.all(pagination)
      render nothing: true
    end

    def create
      @physical_item = resource_class.create(
        scoped_params(:physical_item, :title, :description, :qty)
      )
      render nothing: true
    end

    def show
      @physical_item = resource
      render nothing: true
    end

    def update
      @physical_item = update_resource(:physical_item, :title, :description, :qty)
      render nothing: true
    end

    def activate
      @physical_item = resource
      @physical_item.activate!
      render nothing: true
    end

    def destroy
      @physical_item = resource
      @physical_item.delete!
      render nothing: true
    end

    private

    def set_resource_class
      @resource_class = BackendClient::PhysicalItem
    end
  end
end
