module Inventory
  class BundledsController < ApplicationController
    def destroy
      @bundle = BackendClient::Bundle.find(scoped_params(:bundle_id))
      @bundle.delete_bundled(id)
      redirect_to :back
    end
  end
end
