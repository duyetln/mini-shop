require "spec_helper"
require "sku_service_spec"

describe PhysicalSkusService do

  it_behaves_like "sku service", PhysicalSku
end