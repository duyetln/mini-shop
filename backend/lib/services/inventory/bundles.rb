require 'services/base'

module Services
  module Inventory
    class Bundles < Services::Base
      get '/' do
        bundles = paginate(Bundle).all
        respond_with(bundles.map do |item|
          BundleSerializer.new(item)
        end)
      end

      get '/:id' do
          bundle = Bundle.find(id)
          respond_with(BundleSerializer.new(bundle))
        end

      post '/' do
        bundle = Bundle.new(params[:bundle])
        bundle.save!
        respond_with(BundleSerializer.new(bundle))
      end

      put '/:id' do
        bundle = Bundle.find(id)
        bundle.update_attributes!(params[:bundle])
        respond_with(BundleSerializer.new(bundle))
      end

      post '/:id/bundleds' do
        bundle = Bundle.find(id)
        bundle.add_or_update(
          constantize!(bundled_params[:item_type]).find(bundled_params[:item_id]),
          bundled_params[:qty].to_i,
          false
        ) || unprocessable!(
          message: 'Unable to add or update item',
          meta: 'The bundle is not modifiable currently'
        )
        respond_with(BundleSerializer.new(bundle))
      end

      delete '/:id/bundleds/:bundled_id' do
        bundle = Bundle.find(id)
        bundled = bundle.bundleds.find(params[:bundled_id])
        bundle.remove(bundled) || unprocessable!(
          message: 'Unable to remove item',
          meta: 'The bundle is not modifiable currently'
        )
        respond_with(BundleSerializer.new(bundle))
      end

      put '/:id/activate' do
        bundle = Bundle.find(id)
        bundle.activate! || unprocessable!(
          message: 'Unable to activate bundle',
          meta: 'The bundle is not activable or not ready for activation'
        )
        respond_with(BundleSerializer.new(bundle))
      end

      delete '/:id' do
        bundle = Bundle.find(id)
        bundle.delete! || unprocessable!(
          message: 'Unable to delete bundle',
          meta: 'The bundle is not deletable or not allowed for deletion'
        )
        respond_with(BundleSerializer.new(bundle))
      end

      protected

      def bundled_params
        params[:bundled] || {}
      end
    end
  end
end
