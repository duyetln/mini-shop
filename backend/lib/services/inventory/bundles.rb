require 'services/base'
require 'services/serializers/inventory'

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

      post '/bundles/:id/bundleds' do
        process_request do
          bundle = Bundle.inactive.find(params[:id])
          bundle.add_or_update(
            bundled_params[:item_type].classify.constantize.find(bundled_params[:item_id]),
            bundled_params[:qty].to_i,
            false
          )
          respond_with(BundleSerializer.new(bundle))
        end
      end

      delete '/bundles/:id/bundleds/:bundled_id' do
        process_request do
          bundle = Bundle.inactive.find(params[:id])
          bundled = bundle.bundleds.find(params[:bundled_id])
          bundle.remove(bundled)
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
          bundle = Bundle.inactive.find(params[:id])
          bundle.delete!
          respond_with(BundleSerializer.new(bundle))
        end
      end

      protected

      def bundled_params
        params[:bundled] || {}
      end
    end
  end
end
