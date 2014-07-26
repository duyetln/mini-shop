module Inventory
  class BundlesController < ApplicationController
    def index
      @bundles = resource_class.all(pagination)
      render nothing: true
    end

    def create
      @bundle = resource_class.create(
        scoped_params(:bundle, :title, :description)
      )

      scoped_params(:bundleds).each do |bundled|
        @bundle.add_or_update_bundled(
          bundled.permit(:item_type, :item_id, :qty)
        )
      end
      render nothing: true
    end

    def show
      @bundle   = resource
      @bundleds = @bundle.bundleds
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
      render nothing: true
    end

    def destroy
      @bundle = resource
      @bundle.delete!
      render nothing: true
    end

    private

    def set_resource_class
      @resource_class = BackendClient::Bundle
    end
  end
end
