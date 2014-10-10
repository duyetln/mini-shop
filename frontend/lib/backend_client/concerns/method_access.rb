module BackendClient
  module MethodAccess
    extend ActiveSupport::Concern
    include Hashie::Extensions::MethodAccess

    included do
      delegate :key?, to: :attributes
      delegate :[], to: :attributes
      delegate :[]=, to: :attributes
      delegate :merge!, to: :attributes

      protected :key?
    end

    def attributes
      @attributes ||= {}
    end
  end
end
