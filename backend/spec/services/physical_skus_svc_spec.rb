require "spec_helper"
require "sku_svc_shared"

describe PhysicalSkusSvc do

  it_behaves_like "sku service", PhysicalSku
end