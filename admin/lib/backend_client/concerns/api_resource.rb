module BackendClient
  module APIResource
    extend ActiveSupport::Concern
    include Errors

    module ClassMethods
      def get(path: nil, payload: {}, headers: {})
        handle_error { parse(resource(path).get headers.merge(params: payload)) }
      end

      def post(path: nil, payload: {}, headers: {})
        handle_error { parse(resource(path).post payload, headers) }
      end

      def put(path: nil, payload: {}, headers: {})
        handle_error { parse(resource(path).put payload, headers) }
      end

      def delete(path: nil, payload: {}, headers: {})
        handle_error { parse(resource(path).delete headers.merge(params: payload)) }
      end

      protected

      def resource(path = nil)
        resource = RestClient::Resource.new("#{BackendClient.url}/svc/#{name.demodulize.underscore.pluralize}")
        resource = resource[path] if path.present?
        resource
      end

      def parse(response)
        Yajl::Parser.parse(response, symbolize_keys: true)
      end
    end
  end
end
