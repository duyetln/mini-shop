module BackendClient
  module APIModel
    extend ActiveSupport::Concern
    include MethodAccess

    delegate :as_json, to: :attributes

    class << self
      def instantiate(hash = {})
        BackendClient.const_get(hash[:resource_type]).instantiate(hash)
      end
    end

    def ==(other)
      super ||
        other.instance_of?(self.class) &&
        id.present? &&
        other.id == id
    end

    def eql?(other)
      self.==(other)
    end

    def hash
      [self.class.name, self.id].hash
    end

    def initialize(hash = {})
      @attributes = Hashie::Mash.new
      @backup_attributes = {}
      @cache = {}
      load!(hash)
    end

    def to_params(*slices)
      self.class.params(attributes.symbolize_keys.slice(*slices.map(&:to_sym)))
    end

    def reload!
      load!(@backup_attributes)
    end

    protected

    def load!(hash = {})
      if hash.present?
        attributes.replace(self.class.build_attributes(hash))
        @backup_attributes = hash
        @cache = {}
      end
      self
    end

    module ClassMethods
      def params(hash = {})
        { name.demodulize.underscore.to_sym => hash }
      end

      def humanized_name
        name.demodulize.humanize.downcase
      end

      def instantiate(hash = {})
        if hash.present?
          new(hash)
        end
      end

      def build_attributes(hash = {})
        if hash.present?
          object = Hashie::Mash.new(hash.deep_dup)
          object.created_at = DateTime.parse(object.created_at) if object.created_at.present?
          object.updated_at = DateTime.parse(object.updated_at) if object.updated_at.present?
          yield object if block_given?
          object
        else
          {}
        end
      end
    end
  end
end
