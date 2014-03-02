require "spec_helper"
require "item_resource_helper"

describe DigitalItem do

  let(:item_class) { described_class }

  it_behaves_like "item resource"
end