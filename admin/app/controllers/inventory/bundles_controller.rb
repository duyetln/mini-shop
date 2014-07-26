module Inventory
  class BundlesController < ApplicationController
    def index
      @bundles = BackendClient::Bundle.all(pagination)
      render nothing: true
    end

    def create
      @bundle = BackendClient::Bundle.create(params.require(:bundle).permit(:title, :description))
      params.require(:bundleds).each do |bundled|
        @bundle.add_or_update_bundled(bundled.permit(:item_type, :item_id, :qty))
      end
      render nothing: true
    end

    def show
      @bundle = BackendClient::Bundle.find(params.require(:id))
      render nothing: true
    end

    def update
      @bundle = BackendClient::Bundle.find(params.require(:id))
      @bundle.merge!(params.require(:bundle).permit(:title, :description))
      @bundle.update!(:title, :description)
      params.require(:bundleds).each do |bundled|
        @bundle.add_or_update_bundled(bundled.permit(:qty))
      end
      render nothing: true
    end

    def activate
      @bundle = BackendClient::Bundle.find(params.require(:id))
      @bundle.activate!
      render nothing: true
    end

    def destroy
      @bundle = BackendClient::Bundle.find(params.require(:id))
      @bundle.delete!
      render nothing: true
    end
  end
end
