module ItemSvcEndpoints
  extend ActiveSupport::Concern

  module ClassMethods

    def generate_endpoints!
      get "/#{namespace}/ping" do
        respond_with({
          active:   settings.item_class.active.count,
          inactive: settings.item_class.inactive.count,
          deleted:  settings.item_class.deleted.count,
          kept: settings.item_class.kept.count,
          total:    settings.item_class.count
        })
      end

      get "/#{namespace}" do
        load_items!
        respond_with(@items)
      end

      get "/#{namespace}/:id" do
        find_item!
        respond_with(@item)
      end

      post "/#{namespace}" do
        load_item!
        respond_with(@item, failure: 400) { |s| s.save }
      end

      put "/#{namespace}/:id" do
        find_item!
        respond_with(@item, failure: 400) { |s| s.update_attributes(accessible_params) }
      end

      delete "/#{namespace}/:id" do
        find_item!
        respond_with(@item) { |s| s.delete! }
      end

      put "/#{namespace}/:id/activate" do
        find_item!
        respond_with(@item) { |s| s.activate! }
      end

      put "/#{namespace}/:id/deactivate" do
        find_item!
        respond_with(@item) { |s| s.deactivate! }
      end

    end

  end

end