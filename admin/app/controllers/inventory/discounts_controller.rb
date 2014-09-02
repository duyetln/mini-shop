module Inventory
  class DiscountsController < ApplicationController
    def index
      @discounts = Discount.all
    end

    def create
      @discount = Discount.create(
        params.require(:discount).permit(:name, :rate, :start_at, :end_at)
      )
      go_back
    end

    def update
      resource = Discount.find(id)
      update_params = params.require(:discount).permit(:name, :rate, :start_at, :end_at)
      begin
        if update_params[:start_at].present?
          update_params[:start_at] = DateTime.strptime(
            update_params[:start_at],
            '%m/%d/%Y %H:%M'
          )
        end

        if update_params[:end_at].present?
          update_params[:end_at] = DateTime.strptime(
            update_params[:end_at],
            '%m/%d/%Y %H:%M'
          )
        end
      rescue ArgumentError
        flash[:error] = 'Date must conform to 2014/11/25 17:30 format'
        redirect_to(:back) and return
      end
      @discount = update_resource(
        resource,
        update_params
      )
      go_back
    end
  end
end
