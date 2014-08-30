module Inventory
  class PromotionsController < ApplicationController
    def index
      @promotions = resource_class.all(sort: :desc)
      @physical_items = BackendClient::PhysicalItem.all(sort: :desc)
      @digital_items = BackendClient::DigitalItem.all(sort: :desc)
      @bundles = BackendClient::Bundle.all(sort: :desc)
      @prices = BackendClient::Price.all(sort: :desc)
    end

    def create
      @promotion = resource_class.create(
        scoped_params(:promotion, :name, :title, :description, :price_id).merge(
          Yajl::Parser.parse scoped_params(:promotion).require(:item)
        )
      )
      redirect_to :back
    end

    def show
      @promotion = resource
      @batches = @promotion.batches(sort: :desc)
      @prices = BackendClient::Price.all(sort: :desc)
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
