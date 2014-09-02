module Inventory
  class DigitalItemsController < ApplicationController
    def index
      @digital_items = DigitalItem.all
    end

    def create
      @digital_item = DigitalItem.create(
        params.require(:digital_item).permit(:title, :description)
      )
      go_back
    end

    def update
      @digital_item = update_resource(
        DigitalItem.find(id),
        params.require(:digital_item).permit(:title, :description)
      )
      go_back
    end

    def activate
      @digital_item = DigitalItem.find(id)
      @digital_item.activate!
      go_back
    end

    def destroy
      @digital_item = DigitalItem.find(id)
      @digital_item.delete!
      go_back
    end
  end
end
