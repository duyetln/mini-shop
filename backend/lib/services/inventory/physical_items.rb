require 'services/base'
require 'models/serializers/inventory'

module Services
  module Inventory
    class PhysicalItems < Services::Base
      get '/' do
        process_request do
          physical_items = PhysicalItem.all
          respond_with(physical_items.map do |item|
            PhysicalItemSerializer.new(item)
          end)
        end
      end

      post '/' do
        process_request do
          physical_item = PhysicalItem.new(params[:physical_item])
          physical_item.save!
          respond_with(PhysicalItemSerializer.new(physical_item))
        end
      end

      put '/:id' do
        process_request do
          physical_item = PhysicalItem.find(params[:id])
          physical_item.update_attributes!(params[:physical_item])
          respond_with(PhysicalItemSerializer.new(physical_item))
        end
      end

      put '/:id/activate' do
        process_request do
          physical_item = PhysicalItem.find(params[:id])
          physical_item.activate! || unprocessable!
          respond_with(PhysicalItemSerializer.new(physical_item))
        end
      end

      delete '/:id' do
        process_request do
          physical_item = PhysicalItem.find(params[:id])
          physical_item.delete! || unprocessable!
          respond_with(PhysicalItemSerializer.new(physical_item))
        end
      end
    end
  end
end
