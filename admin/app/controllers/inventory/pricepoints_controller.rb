module Inventory
  class PricepointsController < ApplicationController
    def index
      @pricepoints = Pricepoint.all
      @currencies = Currency.all
    end

    def create
      @pricepoint = Pricepoint.create(
        params.require(:pricepoint).permit(:name)
      )

      params.require(:pricepoint_prices).each do |value|
        @pricepoint.create_pricepoint_price(
          value.permit(:amount, :currency_id)
        )
      end
      redirect_to :back
    end

    def update
      @pricepoint = update_resource(
        Pricepoint.find(id),
        params.require(:pricepoint).permit(:name)
      )

      params.require(:pricepoint_prices).each do |value|
        pricepoint_price = @pricepoint.pricepoint_prices.find do |pp|
          pp.id == value.require(:id).to_i
        end

        if pricepoint_price.present?
          update_resource(
            pricepoint_price,
            value.permit(:amount)
          )
        else
          @pricepoint.create_pricepoint_price(
            value.permit(:amount, :currency_id)
          )
        end
      end
      redirect_to :back
    end
  end
end
