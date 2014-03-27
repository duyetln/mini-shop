module ItemSvcHelpers
  extend ActiveSupport::Concern

  module ClassMethods

    def generate_helpers!
      helpers do

        protected

        def items
          settings.item_class.unscoped.kept # temporary use "unscoped" now -- the service should be rethought
        end

        def find_item!
          @item = items.find_by_id(params[:id]) || halt(404)
        end

        def load_item!
          @item = settings.item_class.new(accessible_params)
          @item.valid? && @item || halt(400)
        end

        def load_items!
          @items = !!params[:pagination] && items.paginate(params[:offset], params[:limit]) || items
        end

        def item_response_options
          { root: false, except: [ :updated_at ] }
        end

        def accessible_params
          params.slice *settings.item_class.column_names
        end

        def respond_with(resource, response_options={}, json_options=item_response_options)
          resource.present? || halt(404)
          status = block_given? ? yield(resource) : resource
          success_code = response_options[:success] || 200
          failure_code = response_options[:failure] || 500
          status ? halt(success_code, resource.to_json(json_options)) : halt(failure_code)
        end

      end
    end

  end

end