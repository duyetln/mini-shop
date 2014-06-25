class ServiceResource < Hashie::Mash
  def self.resource
    fail 'Must be implemented in derived class'
  end

  def self.parse(hash = {})
    if hash.present?
      hash[:resource_type].constantize.parse(hash)
    end
  end
end
