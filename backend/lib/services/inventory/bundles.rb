require 'services/base'
require 'models/serializers/inventory'

module Services
  module Inventory
    class Bundles < Services::Base
      get '/' do
        process_request do
          bundles = Bundle.all
          respond_with(bundles.map do |item|
            BundleSerializer.new(item)
          end)
        end
      end

      post '/' do
        process_request do
          bundle = Bundle.new(params[:bundle])
          bundle.save!
          respond_with(BundleSerializer.new(bundle))
        end
      end

      put '/:id' do
        process_request do
          bundle = Bundle.find(params[:id])
          bundle.update_attributes!(params[:bundle])
          respond_with(BundleSerializer.new(bundle))
        end
      end

      post '/:id/bundleds' do
        process_request do
          bundle = Bundle.find(params[:id])
          bundle.add_or_update(
            bundled_params[:item_type].classify.constantize.find(bundled_params[:item_id]),
            bundled_params[:qty].to_i,
            false
          ) || unprocessable!
          respond_with(BundleSerializer.new(bundle))
        end
      end

      delete '/:id/bundleds/:bundled_id' do
        process_request do
          bundle = Bundle.find(params[:id])
          bundled = bundle.bundleds.find(params[:bundled_id])
          bundle.remove(bundled) || unprocessable!
          respond_with(BundleSerializer.new(bundle))
        end
      end

      put '/:id/activate' do
        process_request do
          bundle = Bundle.find(params[:id])
          bundle.activate! || unprocessable!
          respond_with(BundleSerializer.new(bundle))
        end
      end

      delete '/:id' do
        process_request do
          bundle = Bundle.find(params[:id])
          bundle.delete! || unprocessable!
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
