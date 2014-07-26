module Inventory
  class PhysicalItemsController < ApplicationController
    def index
      @physical_items = BackendClient::PhysicalItem.all(pagination)
      render nothing: true
    end

    def create
      @physical_item = BackendClient::PhysicalItem.create(params.require(:physical_item).permit(:title, :description, :qty))
      render nothing: true
    end

    def show
      @physical_item = BackendClient::PhysicalItem.find(params.require(:id))
      render nothing: true
    end

    def update
      @physical_item = BackendClient::PhysicalItem.find(params.require(:id))
      @physical_item.merge!(params.require(:physical_item).permit(:title, :description, :qty))
      @physical_item.update!(:title, :description, :qty)
      render nothing: true
    end

    def activate
      @physical_item = BackendClient::PhysicalItem.find(params.require(:id))
      @physical_item.activate!
      render nothing: true
    end

    def destroy
      @physical_item = BackendClient::PhysicalItem.find(params.require(:id))
      @physical_item.delete!
      render nothing: true
    end
  end
end
