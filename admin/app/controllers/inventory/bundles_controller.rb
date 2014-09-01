module Inventory
  class BundlesController < ApplicationController
    def index
      @bundles = resource_class.all
      @physical_items = BackendClient::PhysicalItem.all
      @digital_items = BackendClient::DigitalItem.all
    end

    def create
      @bundle = resource_class.create(
        scoped_params(:bundle, :title, :description)
      )

      scoped_params(:bundleds).map { |bundled| bundled.permit(:item, :qty) }.each do |bundled|
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
      @bundle = resource
      @physical_items = BackendClient::PhysicalItem.all
      @digital_items = BackendClient::DigitalItem.all
    end

    def update
      @bundle = update_resource(:bundle, :title, :description)

      scoped_params(:bundleds).map { |bundled| bundled.permit(:item, :qty) }.each do |bundled|
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
      @bundle = resource
      @bundle.activate!
      redirect_to :back
    end

    def destroy
      @bundle = resource
      @bundle.delete!
      redirect_to :back
    end

    private

    def set_resource_class
      @resource_class = BackendClient::Bundle
    end
  end
end
