load File.expand_path(File.dirname(__FILE__)) + "/sku_svc_filters.rb"
load File.expand_path(File.dirname(__FILE__)) + "/sku_svc_helpers.rb"
load File.expand_path(File.dirname(__FILE__)) + "/sku_svc_endpoints.rb"

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