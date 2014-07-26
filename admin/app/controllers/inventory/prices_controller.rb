module Inventory
  class PricesController < ApplicationController
    def index
      @prices = BackendClient::Price.all(pagination)
      render nothing: true
    end

    def create
      @price = BackendClient::Price.create(params.require(:price).permit(:name, :pricepoint_id, :discount_id))
      render nothing: true
    end

    def update
      @price = BackendClient::Price.find(params.require(:id))
      @price.merge!(params.require(:price).permit(:name, :pricepoint_id, :discount_id))
      @price.update!(:name, :pricepoint_id, :discount_id)
      render nothing: true
    end
  end
end
