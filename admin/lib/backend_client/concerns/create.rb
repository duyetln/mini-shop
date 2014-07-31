module BackendClient
  module DefaultCreate
    extend ActiveSupport::Concern

    module ClassMethods
      def create(params = {})
        if params.present?
          new(post(payload: params(params)))
        end
      end
    end
  end
end
