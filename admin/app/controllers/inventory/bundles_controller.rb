module Inventory
  class BundlesController < ApplicationController
    def index
      @bundles = resource_class.all(pagination)
      @physical_items = clipboard_physical_items
      @digital_items = clipboard_digital_items
    end

    def create
      @bundle = resource_class.create(
        scoped_params(:bundle, :title, :description)
      )

      scoped_params(:bundleds).select { |bundled| !!bundled[:selected] }.each do |bundled|
        @bundle.add_or_update_bundled(
          bundled.permit(:item_type, :item_id, :qty)
        )
      end
      redirect_to :back
    end

    def show
      @bundle   = resource
      @bundleds = @bundle.bundleds
      render nothing: true
    end

    def edit
      @bundle = resource
      render nothing: true
    end

    def update
      @bundle = update_resource(:bundle, :title, :description)
      scoped_params(:bundleds).each do |bundled|
        @bundle.add_or_update_bundled(
          bundled.permit(:qty)
        )
      end
      render nothing: true
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
