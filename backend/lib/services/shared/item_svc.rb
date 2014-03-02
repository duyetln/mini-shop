require "item_svc_filters"
require "item_svc_helpers"
require "item_svc_endpoints"

module ItemSvc
  extend ActiveSupport::Concern

  include ItemSvcFilters
  include ItemSvcHelpers
  include ItemSvcEndpoints

  module ClassMethods

    def generate!
      generate_filters!
      generate_helpers!
      generate_endpoints!
    end

  end

end