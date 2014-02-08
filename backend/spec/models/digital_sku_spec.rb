require "spec_helper"
require "sku_resource_shared"

describe DigitalSku do

  let(:sku_class) { described_class }

  it_behaves_like "sku resource"
end