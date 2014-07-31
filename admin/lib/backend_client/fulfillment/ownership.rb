module BackendClient
  class Ownership
    include APIModel

    def self.build_attributes(hash = {})
      super do |ownership|
        ownership.item = APIModel.instantiate(ownership.item)
      end
    end
  end
end
