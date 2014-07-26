module Inventory
  class DiscountsController < ApplicationController
    def index
      @discounts = resource_class.all(pagination)
      render nothing: true
    end

    def create
      @discount = resource_class.create(
        scoped_params(:discount, :name, :rate, :start_at, :end_at)
      )
      render nothing: true
    end

    def update
      @discount = update_resource(:discount, :name, :rate, :start_at, :end_at)
      render nothing: true
    end

    private

    def set_resource_class
      @resource_class = BackendClient::Discount
    end
  end
end
