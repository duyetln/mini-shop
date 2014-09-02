module Inventory
  class PhysicalItemsController < ApplicationController
    def index
      @physical_items = PhysicalItem.all
    end

    def create
      @physical_item = PhysicalItem.create(
        params.require(:physical_item).permit(:title, :description, :qty)
      )
      flash[:success] = 'Physical item created successfully' and go_back
    end

    def update
      @physical_item = update_resource(
        PhysicalItem.find(id),
        params.require(:physical_item).permit(:title, :description, :qty)
      )
      flash[:success] = 'Physical item updated successfully' and go_back
    end

    def activate
      @physical_item = PhysicalItem.find(id)
      @physical_item.activate!
      flash[:success] = 'Physical item activated successfully' and go_back
    end

    def destroy
      @physical_item = PhysicalItem.find(id)
      @physical_item.delete!
      flash[:success] = 'Physical item deleted successfully' and go_back
    end
  end
end
