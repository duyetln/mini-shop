module Inventory
  class PromotionsController < ApplicationController
    def index
      @promotions = BackendClient::Promotion.all(pagination)
      render nothing: true
    end

    def create
      @promotion = BackendClient::Promotion.create(params.require(:promotion).permit(:name, :title, :description, :item_type, :item_id, :price_id))
      render nothing: true
    end

    def show
      @promotion = BackendClient::Promotion.find(params.require(:id))
      render nothing: true
    end

    def update
      @promotion = BackendClient::Promotion.find(params.require(:id))
      @promotion.merge!(params.require(:promotion).permit(:name, :title, :description, :price_id))
      @promotion.update!(:name, :title, :description, :price_id)
      render nothing: true
    end

    def activate
      @promotion = BackendClient::Promotion.find(params.require(:id))
      @promotion.activate!
      render nothing: true
    end

    def destroy
      @promotion = BackendClient::Promotion.find(params.require(:id))
      @promotion.delete!
      render nothing: true
    end

    def batches
      @promotion = BackendClient::Promotion.find(params.require(:id))
      @promotion.create_batches(params.require(:qty), params.require(:batch).require(:size))
      render nothing: true
    end
  end
end
