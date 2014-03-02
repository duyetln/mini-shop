module ItemSvcFilters
  extend ActiveSupport::Concern

  module ClassMethods

    def generate_filters!
      before { content_type :json }
    end

  end

end