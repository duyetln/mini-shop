module Inventory
  class DiscountsController < ApplicationController
    def index
      @discounts = BackendClient::Discount.all(pagination)
      render nothing: true
    end

    def create
      @discount = BackendClient::Discount.create(params.require(:discount).permit(:name, :rate, :start_at, :end_at))
      render nothing: true
    end

    def update
      @discount = BackendClient::Discount.find(params.require(:id))
      @discount.merge!(params.require(:discount).permit(:name, :rate, :start_at, :end_at))
      @discount.update!(:name, :rate, :start_at, :end_at)
      render nothing: true
    end
  end
end
