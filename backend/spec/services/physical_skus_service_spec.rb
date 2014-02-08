require "spec_helper"
require "sku_service_shared"

describe PhysicalSkusService do

  it_behaves_like "sku service", PhysicalSku
end