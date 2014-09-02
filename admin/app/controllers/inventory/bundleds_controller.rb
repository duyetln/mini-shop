module Inventory
  class BundledsController < ApplicationController
    def destroy
      @bundle = Bundle.find(params.require(:bundle_id))
      @bundle.delete_bundled(id)
      flash[:success] = 'Item removed from bundle' and go_back
    end
  end
end
