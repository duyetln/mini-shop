require "spec_helper"
require "sku_svc_shared"

describe BundleSkusSvc do

  it_behaves_like "sku service", BundleSku
end