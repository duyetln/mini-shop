require "spec_helper"
require "sku_service_shared"

describe DigitalSkusService do

  it_behaves_like "sku service", DigitalSku
end