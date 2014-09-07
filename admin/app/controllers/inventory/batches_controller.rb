module Inventory
  class BatchesController < ApplicationController
    def show
      @batch   = Batch.find(id)
      @coupons = @batch.coupons
    end

    def update
      @batch = update_resource(
        Batch.find(id),
        params.require(:batch).permit(:name)
      )
      flash[:success] = 'Batch updated successfully' and go_back
    end

    def activate
      @batch = Batch.find(id)
      @batch.activate!
      flash[:success] = 'Batch activated successfully' and go_back
    end

    def destroy
      @batch = Batch.find(id)
      @batch.delete!
      flash[:success] = 'Batch deleted successfully' and go_back
    end

    def coupons
      @batch = Batch.find(id)
      @batch.create_coupons(
        params.require(:qty)
      )
      flash[:success] = 'Coupons created successfully' and go_back
    end
  end
end
