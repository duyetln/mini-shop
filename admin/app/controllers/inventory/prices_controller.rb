module Inventory
  class PricesController < ApplicationController
    def index
      @prices = resource_class.all
      @pricepoints = BackendClient::Pricepoint.all
      @discounts = BackendClient::Discount.all
    end

    def create
      @price = resource_class.create(
        scoped_params(:price, :name, :pricepoint_id, :discount_id)
      )
      redirect_to :back
    end

    def update
      @price = update_resource(:price, :name, :pricepoint_id, :discount_id)
      redirect_to :back
    end

    private

    def set_resource_class
      @resource_class = BackendClient::Price
    end
  end
end
