module SkuSvcEndpoints
  extend ActiveSupport::Concern

  module ClassMethods

    def generate_endpoints!
      get "/#{namespace}" do
        load_skus!
        respond_with(@skus)
      end

      get "/#{namespace}/:id" do
        find_sku!
        respond_with(@sku)
      end

      post "/#{namespace}" do
        load_sku!
        respond_with(@sku) { |s| s.save }
      end

      put "/#{namespace}/:id" do
        find_sku!
        respond_with(@sku, failure: 400) { |s| s.update_attributes(accessible_params) }
      end

      delete "/#{namespace}/:id" do
        find_sku!
        respond_with(@sku) { |s| s.delete! }
      end

      put "/#{namespace}/:id/activate" do
        find_sku!
        respond_with(@sku) { |s| s.activate! }
      end

      put "/#{namespace}/:id/deactivate" do
        find_sku!
        respond_with(@sku) { |s| s.deactivate! }
      end

      post "/#{namespace}/:id/fulfill" do
        find_sku!
      end
    end

  end

end