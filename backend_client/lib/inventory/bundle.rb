require 'lib/base'

module BackendClient
  class Bundle < Base
    include DefaultAll
    include DefaultFind
    include DefaultCreate
    include DefaultUpdate
    include DefaultActivate
    include DefaultDelete

    def self.instantiate(hash = {})
      super do |bundle|
        bundle.bundleds.map! do |bundled|
          Bundled.instantiate(bundled)
        end
      end
    end

    def add_or_update_bundled(bundled = {})
      if bundled.present?
        catch_error RestClient::UnprocessableEntity do
          fail BackendClient::Errors::Unprocessable.new(
            "Unable to add item to #{humanized_name}",
            "The #{humanized_name} is not allowed for modification currently"
          )
        end
        handle_error do
          self.class.parse(
            self.class.resource["/#{id}/bundleds"].post Bundled.params(bundled)
          ) do |hash|
            load!(hash)
            bundleds.last
          end
        end
      end
    end

    def delete_bundled(bundled_id)
      catch_error RestClient::UnprocessableEntity do
        fail BackendClient::Errors::Unprocessable.new(
          "Unable to remove item from #{humanized_name}",
          "The #{humanized_name} is not allowed for modification currently"
        )
      end
      handle_error do
        self.class.parse(
          self.class.resource["/#{id}/bundleds/#{bundled_id}"].delete
        ) do |hash|
          load!(hash)
          bundleds.count
        end
      end
    end
  end
end
