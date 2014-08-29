module Inventory
  class DigitalItemsController < ApplicationController
    def index
      @digital_items = resource_class.all(pagination)
      render nothing: true
    end

    def create
      @digital_item = resource_class.create(
        scoped_params(:digital_item, :title, :description)
      )
      render nothing: true
    end

    def show
      @digital_item = resource
      render nothing: true
    end

    def update
      @digital_item = update_resource(:digital_item, :title, :description)
      render nothing: true
    end

    def activate
      @digital_item = resource
      @digital_item.activate!
      render nothing: true
    end

    def destroy
      @digital_item = resource
      @digital_item.delete!
      render nothing: true
    end

    private

    def set_resource_class
      @resource_class = BackendClient::DigitalItem
    end
  end
end
