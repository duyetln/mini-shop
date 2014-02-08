require "spec_helper"
require "sku_svc_shared"

describe StorefrontSkusSvc do

  it_behaves_like "sku service", StorefrontSku
end