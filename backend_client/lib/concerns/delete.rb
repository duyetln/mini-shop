module BackendClient
  module DefaultDelete
    def delete!
      catch_error RestClient::UnprocessableEntity do
        fail BackendClient::Errors::Unprocessable.new(
          "Unable to delete #{humanized_name}",
          "The #{humanized_name} is not allowed for deletion or already deleted"
        )
      end
      handle_error do
        self.class.parse(
          self.class.resource["/#{id}"].delete
        ) do |hash|
          load!(hash)
        end
      end
    end
  end
end
