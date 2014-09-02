module Inventory
  class PromotionsController < ApplicationController
    def index
      @promotions = Promotion.all
      @physical_items = PhysicalItem.all
      @digital_items = DigitalItem.all
      @bundles = Bundle.all
      @prices = Price.all
    end

    def create
      @promotion = Promotion.create(
        params.require(:promotion).permit(:name, :title, :description, :price_id).merge(
          Yajl::Parser.parse params.require(:promotion).require(:item)
        )
      )
      flash[:success] = 'Promotion created successfully' and go_back
    end

    def show
      @promotion = Promotion.find(id)
      @batches = @promotion.batches
      @prices = Price.all
    end

    def update
      @promotion = update_resource(
        Promotion.find(id),
        params.require(:promotion).permit(:name, :title, :description, :price_id)
      )
      flash[:success] = 'Promotion updated successfully' and go_back
    end

    def activate
      @promotion = Promotion.find(id)
      @promotion.activate!
      flash[:success] = 'Promotion activated successfully' and go_back
    end

    def destroy
      @promotion = Promotion.find(id)
      @promotion.delete!
      flash[:success] = 'Promotion deleted successfully' and go_back
    end

    def batches
      @promotion = Promotion.find(id)
      @promotion.create_batches(
        params.require(:qty),
        params.require(:batch).require(:size)
      )
      go_back
    end
  end
end
