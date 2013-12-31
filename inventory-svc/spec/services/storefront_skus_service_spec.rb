require "spec_helper"
require "sku_service_spec"

describe StorefrontSkusService do

  it_behaves_like "sku service", StorefrontSku
end