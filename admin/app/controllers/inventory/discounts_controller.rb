module Inventory
  class DiscountsController < ApplicationController
    def index
      @discounts = resource_class.all(pagination)
    end

    def create
      @discount = resource_class.create(
        scoped_params(:discount, :name, :rate, :start_at, :end_at)
      )
    end

    def update
      if params[:discount].present?
        begin
          if params[:discount][:start_at].present?
            params[:discount][:start_at] = DateTime.strptime(
              params[:discount][:start_at],
              '%m/%d/%Y %H:%M'
            )
          end

          if params[:discount][:end_at].present?
            params[:discount][:end_at] = DateTime.strptime(
              params[:discount][:end_at],
              '%m/%d/%Y %H:%M'
            )
          end
        rescue ArgumentError
          flash[:error] = {
            primary: 'Invalid date format',
            secondary: 'Date must conform to 2014/11/25 17:30 format'
          }
          redirect_to(:back) and return
        end
      end
      @discount = update_resource(:discount, :name, :rate, :start_at, :end_at)
      redirect_to :back
    end

    private

    def set_resource_class
      @resource_class = BackendClient::Discount
    end
  end
end
