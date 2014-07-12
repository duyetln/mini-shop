require 'services/base'

module Services
  module Inventory
    class StoreItems < Services::Base
      get '/' do
        process_request do
          store_items = paginate(StoreItem).all
          respond_with(store_items.map do |item|
            StoreItemSerializer.new(item)
          end)
        end
      end

      get '/:id' do
        process_request do
          store_item = StoreItem.find(id)
          respond_with(StoreItemSerializer.new(store_item))
        end
      end

      post '/' do
        process_request do
          store_item = StoreItem.new(params[:store_item])
          store_item.save!
          respond_with(StoreItemSerializer.new(store_item))
        end
      end

      put '/:id' do
        process_request do
          store_item = StoreItem.find(id)
          store_item.update_attributes!(params[:store_item])
          respond_with(StoreItemSerializer.new(store_item))
        end
      end

      delete '/:id' do
        process_request do
          store_item = StoreItem.find(id)
          store_item.delete!
          respond_with(StoreItemSerializer.new(store_item))
        end
      end
    end
  end
end
