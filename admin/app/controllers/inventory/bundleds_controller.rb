module Inventory
  class BundledsController < ApplicationController
    def destroy
      @bundle = Bundle.find(params.require(:bundle_id))
      @bundle.delete_bundled(id)
      go_back
    end
  end
end
