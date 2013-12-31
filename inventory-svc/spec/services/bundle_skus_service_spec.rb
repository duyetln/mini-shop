require "spec_helper"
require "sku_service_spec"

describe BundleSkusService do

  it_behaves_like "sku service", BundleSku
end