module BackendClient
  module DefaultFind
    extend ActiveSupport::Concern

    module ClassMethods
      def find(id)
        catch_error RestClient::ResourceNotFound do
          fail BackendClient::Errors::NotFound.new(
            "Unable to find #{humanized_name}",
            "The #{humanized_name} id is invalid"
          )
        end
        handle_error do
          parse(resource["/#{id}"].get) do |hash|
            instantiate(hash)
          end
        end
      end
    end
  end
end
