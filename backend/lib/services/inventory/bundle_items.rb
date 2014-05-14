require 'services/base'
require 'models/serializers/inventory'

module Services
  module Inventory
    class BundleItems < Services::Base
      get '/bundle_items' do
        process_request do
          bundle_items = BundleItem.all
          respond_with(bundle_items.map do |item|
            BundleItemSerializer.new(item)
          end)
        end
      end

      post '/bundle_items' do
        process_request do
          bundle_item = BundleItem.new(params[:bundle_item])
          bundle_item.save!
          respond_with(BundleItemSerializer.new(bundle_item))
        end
      end

      put '/bundle_items/:id' do
        process_request do
          bundle_item = BundleItem.find(params[:id])
          bundle_item.update_attributes!(params[:bundle_item])
          respond_with(BundleItemSerializer.new(bundle_item))
        end
      end

      post '/bundle_items/:id/bundlings' do
        process_request do
          bundle_item = BundleItem.find(params[:id])
          bundle_item.add_or_update(
            bundling_params[:item_type].classify.constantize.find(bundling_params[:item_id]),
            bundling_params[:qty].to_i,
            false
          )
          respond_with(BundleItemSerializer.new(bundle_item))
        end
      end

      delete '/bundle_items/:id/bundlings/:bundling_id' do
        process_request do
          bundle_item = BundleItem.find(params[:id])
          bundling = bundle_item.bundlings.find(params[:bundling_id])
          bundle_item.remove(bundling)
          respond_with(BundleItemSerializer.new(bundle_item))
        end
      end

      put '/bundle_items/:id/activate' do
        process_request do
          bundle_item = BundleItem.inactive.find(params[:id])
          bundle_item.activate!
          respond_with(BundleItemSerializer.new(bundle_item))
        end
      end

      delete '/bundle_items/:id' do
        process_request do
          bundle_item = BundleItem.find(params[:id])
          bundle_item.delete!
          respond_with(BundleItemSerializer.new(bundle_item))
        end
      end

      protected

      def bundling_params
        params[:bundling] || {}
      end
    end
  end
end
