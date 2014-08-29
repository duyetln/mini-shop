module Inventory
  class PromotionsController < ApplicationController
    def index
      @promotions = resource_class.all(sort: :desc)
      @bundles = clipboard_bundles
      @physical_items = clipboard_physical_items
      @digital_items = clipboard_digital_items
      @prices = clipboard_prices
    end

    def create
      @promotion = resource_class.create(
        scoped_params(:promotion, :name, :title, :description, :price_id).merge(
          scoped_params(:items).find { |item| !!item[:selected] }.permit(:item_type, :item_id)
        )
      )
      redirect_to :back
    end

    def show
      @promotion = resource
      @batches   = @promotion.batches(sort: :desc)
      @prices    = clipboard_prices
    end

    def update
      @promotion = update_resource(:promotion, :name, :title, :description, :price_id)
      redirect_to :back
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
      redirect_to :back
    end

    private

    def set_resource_class
      @resource_class = BackendClient::Promotion
    end
  end
end
