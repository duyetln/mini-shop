module BackendClient
  module DefaultFind
    extend ActiveSupport::Concern

    module ClassMethods
      def find(id)
        parse(resource["/#{id}"].get) do |hash|
          instantiate(hash)
        end
      end
    end
  end
end
