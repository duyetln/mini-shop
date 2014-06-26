class Ownership < ServiceResource
  def self.instantiate(hash = {})
    super do |ownership|
      ownership.item = ServiceResource.concretize(ownership.item)
    end
  end
end
