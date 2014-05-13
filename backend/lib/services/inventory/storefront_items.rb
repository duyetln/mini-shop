require 'services/base'
require 'models/serializers/inventory'

module Services
  module Inventory
    class StorefrontItems < Services::Base
      get '/storefront_items' do
        process_request do
          storefront_items = StorefrontItem.all
          respond_with(storefront_items.map do |item|
            StorefrontItemSerializer.new(item)
          end)
        end
      end

      post '/storefront_items' do
        process_request do
          storefront_item = StorefrontItem.new(params[:storefront_item])
          storefront_item.save!
          respond_with(StorefrontItemSerializer.new(storefront_item))
        end
      end

      put '/storefront_items/:id' do
        process_request do
          storefront_item = StorefrontItem.find(params[:id])
          storefront_item.update_attributes!(params[:storefront_item])
          respond_with(StorefrontItemSerializer.new(storefront_item))
        end
      end

      put '/storefront_items/:id/activate' do
        process_request do
          storefront_item = StorefrontItem.inactive.find(params[:id])
          storefront_item.activate!
          respond_with(StorefrontItemSerializer.new(storefront_item))
        end
      end

      delete '/storefront_items/:id' do
        process_request do
          storefront_item = StorefrontItem.find(params[:id])
          storefront_item.delete!
          respond_with(StorefrontItemSerializer.new(storefront_item))
        end
      end
    end
  end
end
