module Inventory
  class DigitalItemsController < ApplicationController
    def index
      @digital_items = resource_class.all(sort: :desc)
    end

    def create
      @digital_item = resource_class.create(
        scoped_params(:digital_item, :title, :description)
      )
      redirect_to :back
    end

    def update
      @digital_item = update_resource(:digital_item, :title, :description)
      redirect_to :back
    end

    def activate
      @digital_item = resource
      @digital_item.activate!
      redirect_to :back
    end

    def destroy
      @digital_item = resource
      @digital_item.delete!
      redirect_to :back
    end

    private

    def set_resource_class
      @resource_class = BackendClient::DigitalItem
    end
  end
end
