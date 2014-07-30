module BackendClient
  module DefaultFind
    extend ActiveSupport::Concern

    module ClassMethods
      def find(id)
        new(get path: "/#{id}")
      end
    end
  end
end
