require 'lib/base'

module BackendClient
  class Bundle < Base
    extend DefaultAll
    extend DefaultFind
    extend DefaultCreate
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
        self.class.parse(
          self.class.resource["/#{id}/bundleds"].post Bundled.params(bundled)
        ) do |hash|
          load!(hash)
          bundleds.last
        end
      end
    end

    def delete_bundled(bundled_id)
      self.class.parse(
        self.class.resource["/#{id}/bundleds/#{bundled_id}"].delete
      ) do |hash|
        load!(hash)
        bundleds.count
      end
    end
  end
end
