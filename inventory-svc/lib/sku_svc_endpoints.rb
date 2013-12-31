module SkuSvcEndpoints
  extend ActiveSupport::Concern

  module ClassMethods

    def generate_endpoints!
      get "/#{namespace}/ping" do
        respond_with({
          active:   settings.sku_class.active.count,
          inactive: settings.sku_class.inactive.count,
          removed:  settings.sku_class.removed.count,
          retained: settings.sku_class.retained.count,
          total:    settings.sku_class.count
        })
      end

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
        respond_with(@sku, failure: 400) { |s| s.save }
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