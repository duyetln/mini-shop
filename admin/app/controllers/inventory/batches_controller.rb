module Inventory
  class BatchesController < ApplicationController
    def show
      @batch   = resource
      @coupons = @batch.coupons(sort: :desc)
    end

    def update
      @batch = update_resource(:batch, :name)
      redirect_to :back
    end

    def activate
      @batch = resource
      @batch.activate!
      redirect_to :back
    end

    def destroy
      @batch = resource
      @batch.delete!
      redirect_to :back
    end

    def coupons
      @batch = resource
      @batch.create_coupons(
        scoped_params(:qty)
      )
      redirect_to :back
    end

    private

    def set_resource_class
      @resource_class = BackendClient::Batch
    end
  end
end
