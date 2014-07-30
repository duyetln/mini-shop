require 'services/base'

module Services
  module Inventory
    class DigitalItems < Services::Base
      get '/' do
        digital_items = paginate(DigitalItem).all
        respond_with(digital_items.map do |item|
          DigitalItemSerializer.new(item)
        end)
      end

      get '/:id' do
        digital_item = DigitalItem.find(id)
        respond_with(DigitalItemSerializer.new(digital_item))
      end

      post '/' do
        digital_item = DigitalItem.new(params[:digital_item])
        digital_item.save!
        respond_with(DigitalItemSerializer.new(digital_item))
      end

      put '/:id' do
        digital_item = DigitalItem.find(id)
        digital_item.update_attributes!(params[:digital_item])
        respond_with(DigitalItemSerializer.new(digital_item))
      end

      put '/:id/activate' do
        digital_item = DigitalItem.find(id)
        digital_item.activate! || unprocessable!(
          message: 'Unable to activate digital item',
          meta: 'The digital item is not ready for activation'
        )
        respond_with(DigitalItemSerializer.new(digital_item))
      end

      delete '/:id' do
        digital_item = DigitalItem.find(id)
        digital_item.delete! || unprocessable!(
          message: 'Unable to delete digital item',
          meta: 'The digital item is not deletable or not allowed for deletion'
        )
        respond_with(DigitalItemSerializer.new(digital_item))
      end
    end
  end
end
