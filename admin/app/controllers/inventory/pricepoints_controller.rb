module Inventory
  class PricepointsController < ApplicationController
    def index
      @pricepoints = BackendClient::Pricepoint.all(pagination)
      @currencies = BackendClient::Currency.all
    end

    def create
      @pricepoint = resource_class.create(
        scoped_params(:pricepoint, :name)
      )

      scoped_params(:pricepoint_prices).each do |value|
        @pricepoint.create_pricepoint_price(
          value.permit(:amount, :currency_id)
        )
      end
      redirect_to :back
    end

    def edit
      @pricepoint = resource
      @currencies = BackendClient::Currency.all
    end

    def update
      @pricepoint = update_resource(:pricepoint, :name)
      scoped_params(:pricepoint_prices).each do |value|
        pricepoint_price = @pricepoint.pricepoint_prices.find do |pp|
          pp.id == value.require(:id).to_i
        end

        if pricepoint_price.present?
          pricepoint_price.merge!(value.permit(:amount))
          pricepoint_price.update!(:amount)
        else
          @pricepoint.create_pricepoint_price(
            value.permit(:amount, :currency_id)
          )
        end
      end
      redirect_to :back
    end

    private

    def set_resource_class
      @resource_class = BackendClient::Pricepoint
    end
  end
end
