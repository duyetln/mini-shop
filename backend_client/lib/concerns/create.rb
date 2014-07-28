module BackendClient
  module DefaultCreate
    extend ActiveSupport::Concern

    module ClassMethods
      def create(params = {})
        if params.present?
          parse(resource.post params(params)) do |hash|
            instantiate(hash)
          end
        end
      end
    end
  end
end
