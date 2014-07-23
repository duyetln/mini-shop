require 'services/base'

module Services
  module Inventory
    class PhysicalItems < Services::Base
      get '/' do
        physical_items = paginate(PhysicalItem).all
        respond_with(physical_items.map do |item|
          PhysicalItemSerializer.new(item)
        end)
      end

      get '/:id' do
        physical_item = PhysicalItem.find(id)
        respond_with(PhysicalItemSerializer.new(physical_item))
      end

      post '/' do
        physical_item = PhysicalItem.new(params[:physical_item])
        physical_item.save!
        respond_with(PhysicalItemSerializer.new(physical_item))
      end

      put '/:id' do
        physical_item = PhysicalItem.find(id)
        physical_item.update_attributes!(params[:physical_item])
        respond_with(PhysicalItemSerializer.new(physical_item))
      end

      put '/:id/activate' do
        physical_item = PhysicalItem.find(id)
        physical_item.activate! || unprocessable!
        respond_with(PhysicalItemSerializer.new(physical_item))
      end

      delete '/:id' do
        physical_item = PhysicalItem.find(id)
        physical_item.delete! || unprocessable!
        respond_with(PhysicalItemSerializer.new(physical_item))
      end
    end
  end
end
