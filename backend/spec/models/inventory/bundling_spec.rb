require 'models/spec_setup'
require 'spec/models/shared/item_combinable'

describe Bundling do

  it_behaves_like 'item combinable model'

  it { should have_readonly_attribute(:bundle_id) }

  it { should belong_to(:bundle) }

  it { should validate_presence_of(:bundle) }

  it { should ensure_inclusion_of(:item_type).in_array(%w{ DigitalItem PhysicalItem }) }

end
