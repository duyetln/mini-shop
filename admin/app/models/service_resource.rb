class ServiceResource < Hashie::Mash
  module DefaultAll
    def all
      parse(resource.get).map do |hash|
        instantiate(hash)
      end.compact
    end
  end

  module DefaultCreate
    def create(params = {})
      if params.present?
        parse(resource.post currency: params) do |hash|
          instantiate(hash)
        end
      end
    end
  end

  module DefaultFind
    def find(id)
      parse(resource["#{id}"].get) do |hash|
        instantiate(hash)
      end
    end
  end

  module DefaultUpdate
    def update!
      if attributes.present?
        self.class.parse(
          self.class.resource["#{id}"].put(
            self.class.name.underscore.symbolize => attributes
          )
        ) do |hash|
          load!(hash)
        end
      end
    end
  end
end

class ServiceResource < Hashie::Mash
  alias_method :attributes, :to_hash

  def ==(comparison_object)
    super ||
      comparison_object.instance_of?(self.class) &&
      id.present? &&
      comparison_object.id == id
  end

  def self.resource
    RestClient::Resource.new "localhost:8002/svc/#{name.underscore.pluralize}"
  end

  def self.concretize(hash = {})
    if hash.present?
      hash[:resource_type].constantize.instantiate(hash)
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

  def load!(hash = {})
    replace(self.class.instantiate(hash).attributes) if hash.present?
  end

  def self.parse(response)
    parsed_response = Yajl::Parser.parse(response, symbolize_keys: true)
    block_given? ? yield(parsed_response) : parsed_response
  end
end
