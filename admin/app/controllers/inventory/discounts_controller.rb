module Inventory
  class DiscountsController < ApplicationController
    def index
      @discounts = Discount.all
    end

    def create
      @params = params.require(:discount).permit(:name, :rate, :start_at, :end_at)
      go_back and return unless parse_dates
      @discount = Discount.create(@params)
      flash[:success] = 'Discount created successfully' and go_back
    end

    def update
      @params = params.require(:discount).permit(:name, :rate, :start_at, :end_at)
      go_back and return unless parse_dates
      @discount = update_resource(Discount.find(id), @params)
      flash[:success] = 'Discount updated successfully' and go_back
    end

    protected

    def parse_dates
      begin
        if @params[:start_at].present?
          @params[:start_at] = DateTime.strptime(
            @params[:start_at],
            '%m/%d/%Y %H:%M'
          )
        end

        if @params[:end_at].present?
          @params[:end_at] = DateTime.strptime(
            @params[:end_at],
            '%m/%d/%Y %H:%M'
          )
        end
        true
      rescue ArgumentError
        flash[:error] = 'Date must conform to 11/25/2014 17:30 format'
        false
      end
    end
  end
end
