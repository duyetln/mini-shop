module BackendClient
  module DefaultActivate
    def activate!
      catch_error RestClient::UnprocessableEntity do
        fail BackendClient::Errors::Unprocessable.new(
          "Unable to activate #{humanized_name}",
          "The #{humanized_name} is not ready for activation or already activated"
        )
      end
      handle_error do
        self.class.parse(
          self.class.resource["/#{id}/activate"].put({})
        ) do |hash|
          load!(hash)
        end
      end
    end
  end
end
