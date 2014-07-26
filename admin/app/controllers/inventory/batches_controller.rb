module Inventory
  class BatchesController < ApplicationController
    def show
      @batch = BackendClient::Batch.find(params.require(:id))
      render nothing: true
    end

    def update
      @batch = BackendClient::Batch.find(params.require(:id))
      @batch.merge!(params.require(:batch).permit(:name))
      @batch.update!(:name)
      render nothing: true
    end

    def activate
      @batch = BackendClient::Batch.find(params.require(:id))
      @batch.activate!
      render nothing: true
    end

    def destroy
      @batch = BackendClient::Batch.find(params.require(:id))
      @batch.delete!
      render nothing: true
    end

    def coupons
      @batch = BackendClient::Batch.find(params.require(:id))
      @batch.create_coupons(params.require(:qty))
      render nothing: true
    end
  end
end
