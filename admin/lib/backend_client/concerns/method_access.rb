module BackendClient
  module MethodAccess
    extend ActiveSupport::Concern
    include Hashie::Extensions::MethodAccess

    included do
      delegate :key?, to: :attributes
      delegate :[], to: :attributes
      delegate :[]=, to: :attributes
      attr_reader :attributes

      protected :key?
    end

    def merge!(*args)
      attributes.merge!(*args)
      self
    end
  end
end
