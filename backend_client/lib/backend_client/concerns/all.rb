module BackendClient
  module DefaultAll
    extend ActiveSupport::Concern

    module ClassMethods
      def all(pagination = {})
        get(
          payload: pagination.slice(:page, :size, :padn, :sort)
        ).map do |hash|
          new(hash)
        end
      end
    end
  end
end
