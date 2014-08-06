module Inventory
  class PricepointsController < ApplicationController
    def index
      @pricepoints = BackendClient::Pricepoint.all(pagination)
      @currencies = BackendClient::Currency.all
      render nothing: true
    end

    def create
      @pricepoint = resource_class.create(
        scoped_params(:pricepoint, :name)
      )

      scoped_params(:pricepoint_prices).each do |pricepoint_price|
        @pricepoint.create_pricepoint_price(
          pricepoint_price.permit(:amount, :currency_id)
        )
      end
      render nothing: true
    end

    def update
      @pricepoint = update_resource(:pricepoint, :name)
      scoped_params(:pricepoint_prices).each do |pp_params|
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

    private

    def set_resource_class
      @resource_class = BackendClient::Pricepoint
    end
  end
end
