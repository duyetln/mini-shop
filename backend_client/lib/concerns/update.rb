module BackendClient
  module DefaultUpdate
    def update!(*slices)
      params = to_params(*slices)
      if params.values.all?(&:present?)
        catch_error RestClient::BadRequest do
          fail BackendClient::Errors::BadRequest.new(
            "Unable to update #{humanized_name}",
            (Yajl::Parser.parse(@error.http_body)['message'] rescue nil)
          )
        end
        handle_error do
          self.class.parse(
            self.class.resource["/#{id}"].put(params)
          ) do |hash|
            load!(hash)
          end
        end
      end
    end
  end
end
