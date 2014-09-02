module Inventory
  class BundledsController < ApplicationController
    def destroy
      @bundle = Bundle.find(params.require(:bundle_id))
      @bundle.delete_bundled(id)
      redirect_to :back
    end
  end
end
