module BackendClient
  module MethodAccess
    extend ActiveSupport::Concern
    include Hashie::Extensions::MethodAccess

    included do
      delegate :key?, to: :attributes
      delegate :[], to: :attributes
      delegate :[]=, to: :attributes

      protected :key?
    end

    def attributes
      @attributes ||= {}
    end

    def merge!(*args)
      attributes.merge!(*args)
      self
    end
  end
end
