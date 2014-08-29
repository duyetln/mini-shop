module Inventory
  class BundledsController < ApplicationController
    def destroy
      @bundle = BackendClient::Bundle.find(scoped_params(:bundle_id))
      @bundle.delete_bundled(id)
      render nothing: true
    end
  end
end
