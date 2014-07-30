module BackendClient
  class Bundle < APIModel
    include DefaultAll
    include DefaultFind
    include DefaultCreate
    include DefaultUpdate
    include DefaultActivate
    include DefaultDelete

    def self.build_attributes(hash = {})
      super do |bundle|
        bundle.bundleds.map! do |bundled|
          Bundled.new(bundled)
        end
      end
    end

    def add_or_update_bundled(bundled = {})
      if bundled.present?
        load!(
          self.class.post(
            path: "/#{id}/bundleds",
            payload: Bundled.params(bundled)
          )
        )
        bundleds.last
      end
    end

    def delete_bundled(bundled_id)
      load!(
        self.class.delete(
          path: "/#{id}/bundleds/#{bundled_id}"
        )
      )
      bundleds.count
    end
  end
end
