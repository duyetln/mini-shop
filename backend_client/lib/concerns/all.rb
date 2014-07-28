module BackendClient
  module DefaultAll
    extend ActiveSupport::Concern

    module ClassMethods
      def all(pagination = {})
        parse(
          resource.get params: pagination.slice(:page, :size, :padn)
        ).map do |hash|
          instantiate(hash)
        end.compact
      end
    end
  end
end
