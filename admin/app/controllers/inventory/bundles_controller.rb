module Inventory
  class BundlesController < ApplicationController
    def index
      @bundles = Bundle.all
      @physical_items = PhysicalItem.all
      @digital_items = DigitalItem.all
    end

    def create
      @bundle = Bundle.create(
        params.require(:bundle).permit(:title, :description)
      )

      (params[:bundleds] || []).map { |bundled| bundled.permit(:item, :qty) }.each do |bundled|
        if bundled[:item].present? && bundled[:qty].present?
          @bundle.add_or_update_bundled(
            bundled.permit(:qty).merge(
              Yajl::Parser.parse bundled.require(:item)
            )
          )
        end
      end
      redirect_to :back
    end

    def show
      @bundle = Bundle.find(id)
      @physical_items = PhysicalItem.all
      @digital_items = DigitalItem.all
    end

    def update
      @bundle = update_resource(
        Bundle.find(id),
        params.require(:bundle).permit(:title, :description)
      )

      (params[:bundleds] || []).map { |bundled| bundled.permit(:item, :qty) }.each do |bundled|
        if bundled[:item].present? && bundled[:qty].present?
          @bundle.add_or_update_bundled(
            bundled.permit(:qty).merge(
              Yajl::Parser.parse bundled.require(:item)
            )
          )
        end
      end
      redirect_to :back
    end

    def activate
      @bundle = Bundle.find(id)
      @bundle.activate!
      redirect_to :back
    end

    def destroy
      @bundle = Bundle.find(id)
      @bundle.delete!
      redirect_to :back
    end
  end
end
