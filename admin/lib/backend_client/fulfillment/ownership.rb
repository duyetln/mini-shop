require 'lib/backend_client/base'

module BackendClient
  class Ownership < Base
    def self.instantiate(hash = {})
      super do |ownership|
        ownership.item = Base.concretize(ownership.item)
      end
    end
  end
end
