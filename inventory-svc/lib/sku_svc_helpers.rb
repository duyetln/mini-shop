module SkuSvcHelpers
  extend ActiveSupport::Concern

  module ClassMethods

    def generate_helpers!
      helpers do

        protected

        def skus
          settings.sku_class.retained
        end

        def find_sku!
          @sku = skus.find_by_id(params[:id]) || halt(404)
        end

        def load_sku!
          @sku = settings.sku_class.new(accessible_params)
          @sku.valid? && @sku || halt(400)
        end

        def load_skus!
          @skus = !!params[:pagination] && skus || skus.paginate(params[:offset], params[:limit])
        end

        def sku_response_options
          { except: [ :updated_at ] }
        end

        def accessible_params
          params.slice *settings.sku_class.accessible_attributes.to_a
        end

        def response_with(resource, options={})
          status = block_given? ? yield(resource) : resource
          success_code = options[:success] || 200
          failure_code = options[:failure] || 500
          status ? halt(success_code, resource.to_json(sku_response_options)) : halt(failure_code)
        end

      end
    end

  end

end