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

    protected

    def attributes
      @attributes ||= {}
    end
  end
end
