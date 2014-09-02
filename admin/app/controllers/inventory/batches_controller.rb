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
      go_back
    end

    def activate
      @batch = Batch.find(id)
      @batch.activate!
      go_back
    end

    def destroy
      @batch = Batch.find(id)
      @batch.delete!
      go_back
    end

    def coupons
      @batch = Batch.find(id)
      @batch.create_coupons(
        params.require(:qty)
      )
      go_back
    end
  end
end
