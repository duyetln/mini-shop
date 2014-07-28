module BackendClient
  module ServiceResource
    extend ActiveSupport::Concern

    class << self
      attr_accessor :host

      def proxy=(proxy)
        RestClient.proxy = proxy
      end
    end

    module ClassMethods
      def params(hash = {})
        { namespace.to_sym => hash }
      end

      def namespace
        name.demodulize.underscore
      end

      def resource
        RestClient::Resource.new "#{ServiceResource.host}/svc/#{namespace.pluralize}"
      end

      def parse(response)
        parsed_response = Yajl::Parser.parse(response, symbolize_keys: true)
        block_given? ? yield(parsed_response) : parsed_response
      end
    end
  end
end
