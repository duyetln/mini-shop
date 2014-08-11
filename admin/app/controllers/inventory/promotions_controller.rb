module Inventory
  class PromotionsController < ApplicationController
    def index
      @promotions = resource_class.all(pagination)
    end

    def create
      @promotion = resource_class.create(
        scoped_params(:promotion, :name, :title, :description, :item_type, :item_id, :price_id)
      )
      render nothing: true
    end

    def show
      @promotion = resource
      @batches   = @promotion.batches(pagination)
      @item      = @promotion.item
      @price     = @promotion.price
      render nothing: true
    end

    def update
      @promotion = update_resource(:promotion, :name, :title, :description, :price_id)
      render nothing: true
    end

    def activate
      @promotion = resource
      @promotion.activate!
      redirect_to :back
    end

    def destroy
      @promotion = resource
      @promotion.delete!
      redirect_to :back
    end

    def batches
      @promotion = resource
      @promotion.create_batches(
        scoped_params(:qty),
        scoped_params(:batch).require(:size)
      )
      render nothing: true
    end

    private

    def set_resource_class
      @resource_class = BackendClient::Promotion
    end
  end
end
