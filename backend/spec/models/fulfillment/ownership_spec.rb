require 'models/spec_setup'
require 'spec/models/shared/item_combinable'
require 'spec/models/shared/deletable'

describe Ownership do
  it_behaves_like 'item combinable model'
  it_behaves_like 'deletable model'
  include_examples 'default #deletable?'
end

describe Ownership do
  it { should have_readonly_attribute(:user_id) }
  it { should have_readonly_attribute(:order_id) }

  it { should belong_to(:user) }
  it { should belong_to(:order) }

  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:order) }

  it { should ensure_inclusion_of(:item_type).in_array(%w{ DigitalItem }) }
end
