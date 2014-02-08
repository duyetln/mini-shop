require "spec_helper"
require "sku_svc_shared"

describe DigitalSkusSvc do

  it_behaves_like "sku service", DigitalSku
end