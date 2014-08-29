module Inventory
  class PricesController < ApplicationController
    def index
      @prices = resource_class.all(sort: :desc)
      @pricepoints = BackendClient::Pricepoint.all(sort: :desc)
      @discounts = BackendClient::Discount.all(sort: :desc)
    end

    def show
      @price = resource
      @pricepoints = BackendClient::Pricepoint.all(sort: :desc)
      @discounts = BackendClient::Discount.all(sort: :desc)
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
