require 'services/base'

module Services
  module Inventory
    class DigitalItems < Services::Base
      get '/' do
        process_request do
          digital_items = DigitalItem.all
          respond_with(digital_items.map do |item|
            DigitalItemSerializer.new(item)
          end)
        end
      end

      get '/:id' do
        process_request do
          digital_item = DigitalItem.find(params[:id])
          respond_with(DigitalItemSerializer.new(digital_item))
        end
      end

      post '/' do
        process_request do
          digital_item = DigitalItem.new(params[:digital_item])
          digital_item.save!
          respond_with(DigitalItemSerializer.new(digital_item))
        end
      end

      put '/:id' do
        process_request do
          digital_item = DigitalItem.find(params[:id])
          digital_item.update_attributes!(params[:digital_item])
          respond_with(DigitalItemSerializer.new(digital_item))
        end
      end

      put '/:id/activate' do
        process_request do
          digital_item = DigitalItem.find(params[:id])
          digital_item.activate! || unprocessable!
          respond_with(DigitalItemSerializer.new(digital_item))
        end
      end

      delete '/:id' do
        process_request do
          digital_item = DigitalItem.find(params[:id])
          digital_item.delete! || unprocessable!
          respond_with(DigitalItemSerializer.new(digital_item))
        end
      end
    end
  end
end
