module BackendClient
  module DefaultAll
    def all(pagination = {})
      parse(
        resource.get params: pagination.slice(:page, :size, :padn)
      ).map do |hash|
        instantiate(hash)
      end.compact
    end
  end

  module DefaultCreate
    def create(params = {})
      if params.present?
        parse(resource.post params(params)) do |hash|
          instantiate(hash)
        end
      end
    end
  end

  module DefaultFind
    def find(id)
      parse(resource["/#{id}"].get) do |hash|
        instantiate(hash)
      end
    end
  end

  module DefaultUpdate
    def update!(*slices)
      params = to_params(*slices)
      if params.values.all?(&:present?)
        self.class.parse(
          self.class.resource["/#{id}"].put(params)
        ) do |hash|
          load!(hash)
        end
      end
    end
  end

  module DefaultActivate
    def activate!
      self.class.parse(
        self.class.resource["/#{id}/activate"].put({})
      ) do |hash|
        load!(hash)
      end
    end
  end

  module DefaultDelete
    def delete!
      self.class.parse(
        self.class.resource["/#{id}"].delete
      ) do |hash|
        load!(hash)
      end
    end
  end

  module ServiceResource
    class << self
      attr_accessor :host
    end

    def proxy=(proxy)
      RestClient.proxy = proxy
    end

    def params(hash = {})
      { namespace.to_sym => hash }
    end

    def namespace
      name.demodulize.underscore
    end

    def resource
      RestClient::Resource.new "#{ServiceResource.host}/svc/#{namespace.pluralize}"
    end

    def parse(response)
      parsed_response = Yajl::Parser.parse(response, symbolize_keys: true)
      block_given? ? yield(parsed_response) : parsed_response
    end
  end
end

module BackendClient
  class Base < Hashie::Mash
    extend ServiceResource

    alias_method :attributes, :to_hash

    def ==(other)
      super ||
        other.instance_of?(self.class) &&
        id.present? &&
        other.id == id
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
