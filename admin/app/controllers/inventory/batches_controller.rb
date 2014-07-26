module Inventory
  class BatchesController < ApplicationController
    def show
      @batch = resource
      render nothing: true
    end

    def update
      @batch = update_resource(:batch, :name)
      render nothing: true
    end

    def activate
      @batch = resource
      @batch.activate!
      render nothing: true
    end

    def destroy
      @batch = resource
      @batch.delete!
      render nothing: true
    end

    def coupons
      @batch = resource
      @batch.create_coupons(
        scoped_params(:qty)
      )
      render nothing: true
    end

    private

    def set_resource_class
      @resource_class = BackendClient::Batch
    end
  end
end
