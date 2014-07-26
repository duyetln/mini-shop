module Inventory
  class PricepointsController < ApplicationController
    def index
      @pricepoints = BackendClient::Pricepoint.all(pagination)
      render nothing: true
    end

    def create
      @pricepoint = BackendClient::Pricepoint.create(params.require(:pricepoint).permit(:name))
      params.require(:pricepoint_prices).each do |pricepoint_price|
        @pricepoint.create_pricepoint_price(pricepoint_price.permit(:amount, :currency_id))
      end
      render nothing: true
    end

    def update
      @pricepoint = BackendClient::Pricepoint.find(params.require(:id))
      @pricepoint.merge!(params.require(:pricepoint).permit(:name))
      @pricepoint.update!(:name)
      params.require(:pricepoint_prices).each do |pp_params|
        pricepoint_price = @pricepoint.pricepoint_prices.find do |pp|
          pp.id == pp_params.require(:id).to_i
        end
        if pricepoint_price.present?
          pricepoint_price.merge!(pp_params.permit(:amount))
          pircepoint_price.update!(:amount)
        end
      end
      render nothing: true
    end
  end
end
