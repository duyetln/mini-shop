module Settings
  class ClipboardController < ApplicationController
    def index
      @pricepoints    = clipboard_pricepoints
      @discounts      = clipboard_discounts
      @prices         = clipboard_prices
      @physical_items = clipboard_physical_items
      @digital_items  = clipboard_digital_items
      @bundles        = clipboard_bundles
    end

    def create
      begin
        resource_type = params.require(:resource_type)
        resource_id = params.require(:resource_id)

        if [
          :pricepoints,
          :discounts,
          :prices,
          :physical_items,
          :digital_items,
          :bundles
         ].map(&:to_s)
          .map(&:singularize)
          .map(&:classify)
          .include?(resource_type)
          bucket = send("clipboard_#{resource_type.underscore.pluralize}")
          bucket << "BackendClient::#{resource_type}".constantize.find(resource_id)
          bucket.uniq!(&:id)
        end
      rescue
        flash[:error] = 'Unable to save resource to clipboard'
      end
      redirect_to :back
    end

    def destroy
      [
        :pricepoints,
        :discounts,
        :prices,
        :physical_items,
        :digital_items,
        :bundles
      ].each do |resource|
        (params.permit(resource => [])[resource] || []).each do |resource_id|
          send("clipboard_#{resource}").reject! { |item| item.id == resource_id.to_i }
        end
      end
      redirect_to :back
    end
  end
end
