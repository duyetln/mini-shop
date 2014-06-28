class Bundled < ServiceResource
  def self.instantiate(hash = {})
    super do |bundled|
      bundled.item = ServiceResource.concretize(bundled.item)
    end
  end
end
