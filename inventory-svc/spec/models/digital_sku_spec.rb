require "spec_helper"
require "sku_resource_spec"

describe DigitalSku do

  let(:sku_class) { described_class }

  it_behaves_like "sku resource"
end