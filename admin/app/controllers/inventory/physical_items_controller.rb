module Inventory
  class PhysicalItemsController < ApplicationController
    def index
      @physical_items = PhysicalItem.all
    end

    def create
      @physical_item = PhysicalItem.create(
        params.require(:physical_item).permit(:title, :description, :qty)
      )
      redirect_to :back
    end

    def update
      @physical_item = update_resource(
        PhysicalItem.find(id),
        params.require(:physical_item).permit(:title, :description, :qty)
      )
      redirect_to :back
    end

    def activate
      @physical_item = PhysicalItem.find(id)
      @physical_item.activate!
      redirect_to :back
    end

    def destroy
      @physical_item = PhysicalItem.find(id)
      @physical_item.delete!
      redirect_to :back
    end
  end
end
