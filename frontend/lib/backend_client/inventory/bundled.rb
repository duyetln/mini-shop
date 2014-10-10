module BackendClient
  class Bundled
    include APIModel

    def self.build_attributes(hash = {})
      super do |bundled|
        bundled.item = APIModel.instantiate(bundled.item)
      end
    end
  end
end
