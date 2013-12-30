require "sku_svc_filters"
require "sku_svc_helpers"
require "sku_svc_endpoints"

module SkuService
  extend ActiveSupport::Concern

  include SkuSvcFilters
  include SkuSvcHelpers
  include SkuSvcEndpoints

  module ClassMethods

    def generate!
      generate_filters!
      generate_helpers!
      generate_endpoints!
    end

  end

end