require 'services/base'
require 'models/serializers/inventory'

module Services
  module Inventory
    class Bundles < Services::Base
      get '/bundles' do
        process_request do
          bundles = Bundle.all
          respond_with(bundles.map do |item|
            BundleSerializer.new(item)
          end)
        end
      end

      post '/bundles' do
        process_request do
          bundle = Bundle.new(params[:bundle])
          bundle.save!
          respond_with(BundleSerializer.new(bundle))
        end
      end

      put '/bundles/:id' do
        process_request do
          bundle = Bundle.find(params[:id])
          bundle.update_attributes!(params[:bundle])
          respond_with(BundleSerializer.new(bundle))
        end
      end

      post '/bundles/:id/bundlings' do
        process_request do
          bundle = Bundle.find(params[:id])
          bundle.add_or_update(
            bundling_params[:item_type].classify.constantize.find(bundling_params[:item_id]),
            bundling_params[:qty].to_i,
            false
          )
          respond_with(BundleSerializer.new(bundle))
        end
      end

      delete '/bundles/:id/bundlings/:bundling_id' do
        process_request do
          bundle = Bundle.find(params[:id])
          bundling = bundle.bundlings.find(params[:bundling_id])
          bundle.remove(bundling)
          respond_with(BundleSerializer.new(bundle))
        end
      end

      put '/bundles/:id/activate' do
        process_request do
          bundle = Bundle.inactive.find(params[:id])
          bundle.activate!
          respond_with(BundleSerializer.new(bundle))
        end
      end

      delete '/bundles/:id' do
        process_request do
          bundle = Bundle.find(params[:id])
          bundle.delete!
          respond_with(BundleSerializer.new(bundle))
        end
      end

      protected

      def bundling_params
        params[:bundling] || {}
      end
    end
  end
end
