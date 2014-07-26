module Inventory
  class BundledsController < ApplicationController
    def destroy
      @bundle = BackendClient::Bundle.find(params.require(:bundle_id))
      @bundle.delete_bundled(params.require(:id))
      render nothing: true
    end
  end
end
