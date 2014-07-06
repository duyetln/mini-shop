require 'backend_client/base'

module BackendClient
  class Bundled < Base
    def self.instantiate(hash = {})
      super do |bundled|
        bundled.item = Base.concretize(bundled.item)
      end
    end
  end
end
