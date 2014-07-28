Dir['lib/concerns/*.rb'].each { |f| require f }

module BackendClient
  class Base < Hashie::Mash
    include ServiceResource
    include Errors::Handlers

    alias_method :attributes, :to_hash
    delegate :humanized_name, to: :class

    class << self
      include Errors::Handlers
    end

    def ==(other)
      super ||
        other.instance_of?(self.class) &&
        id.present? &&
        other.id == id
    end

    def self.humanized_name
      name.demodulize.humanize.downcase
    end

    def self.concretize(hash = {})
      if hash.present?
        BackendClient.const_get(hash[:resource_type]).instantiate(hash)
      end
    end

    def self.instantiate(hash = {})
      if hash.present?
        object = new(hash)
        object.created_at = DateTime.parse(object.created_at) if object.created_at.present?
        object.updated_at = DateTime.parse(object.updated_at) if object.updated_at.present?
        yield(object) if block_given?
        object
      end
    end

    def to_params(*slices)
      self.class.params(attributes.symbolize_keys.slice(*slices.map(&:to_sym)))
    end

    def load!(hash = {})
      hash.present? ? replace(self.class.instantiate(hash)) : self
    end
  end
end
