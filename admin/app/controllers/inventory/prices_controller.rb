module Inventory
  class PricesController < ApplicationController
    def index
      @prices = resource_class.all(pagination)
      render nothing: true
    end

    def create
      @price = resource_class.create(
        scoped_params(:price, :name, :pricepoint_id, :discount_id)
      )
      render nothing: true
    end

    def update
      @price = update_resource(:price, :name, :pricepoint_id, :discount_id)
      render nothing: true
    end

    private

    def set_resource_class
      @resource_class = BackendClient::Price
    end
  end
end
