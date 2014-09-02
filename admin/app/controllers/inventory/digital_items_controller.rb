module Inventory
  class DigitalItemsController < ApplicationController
    def index
      @digital_items = DigitalItem.all
    end

    def create
      @digital_item = DigitalItem.create(
        params.require(:digital_item).permit(:title, :description)
      )
      flash[:success] = 'Digital item created successfully' and go_back
    end

    def update
      @digital_item = update_resource(
        DigitalItem.find(id),
        params.require(:digital_item).permit(:title, :description)
      )
      flash[:success] = 'Digital item updated successfully' and go_back
    end

    def activate
      @digital_item = DigitalItem.find(id)
      @digital_item.activate!
      flash[:success] = 'Digital item activated successfully' and go_back
    end

    def destroy
      @digital_item = DigitalItem.find(id)
      @digital_item.delete!
      flash[:success] = 'Digital item deleted successfully' and go_back
    end
  end
end
