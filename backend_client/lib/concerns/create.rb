module BackendClient
  module DefaultCreate
    extend ActiveSupport::Concern

    module ClassMethods
      def create(params = {})
        if params.present?
          catch_error RestClient::BadRequest do
            fail BackendClient::Errors::BadRequest.new(
              "Unable to create #{humanized_name}",
              (Yajl::Parser.parse(@error.http_body)['message'] rescue nil)
            )
          end
          handle_error do
            parse(resource.post params(params)) do |hash|
              instantiate(hash)
            end
          end
        end
      end
    end
  end
end
