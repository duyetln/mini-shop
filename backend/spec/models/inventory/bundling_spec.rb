require "spec_helper"
require "spec/models/shared/item_combinable"

describe Bundling do

  it_behaves_like "item combinable object"

  it { should belong_to(:bundle).class_name("BundleItem") }

  it { should validate_presence_of(:bundle) }

  it { should ensure_inclusion_of(:item_type).in_array(%w{ DigitalItem PhysicalItem }) }

end