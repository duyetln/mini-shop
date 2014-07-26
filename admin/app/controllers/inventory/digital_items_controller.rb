module Inventory
  class DigitalItemsController < ApplicationController
    def index
      @digital_items = BackendClient::DigitalItem.all(pagination)
      render nothing: true
    end

    def create
      @digital_item = BackendClient::DigitalItem.create(params.require(:digital_item).permit(:title, :description))
      render nothing: true
    end

    def show
      @digital_item = BackendClient::DigitalItem.find(params.require(:id))
      render nothing: true
    end

    def update
      @digital_item = BackendClient::DigitalItem.find(params.require(:id))
      @digital_item.merge!(params.require(:digital_item).permit(:title, :description))
      @digital_item.update!(:title, :description)
      render nothing: true
    end

    def activate
      @digital_item = BackendClient::DigitalItem.find(params.require(:id))
      @digital_item.activate!
      render nothing: true
    end

    def destroy
      @digital_item = BackendClient::DigitalItem.find(params.require(:id))
      @digital_item.delete!
      render nothing: true
    end
  end
end
