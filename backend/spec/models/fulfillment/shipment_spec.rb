require 'models/spec_setup'
require 'spec/models/shared/item_combinable'

describe Shipment do
  it_behaves_like 'item combinable model'
end

describe Shipment do

  it { should have_readonly_attribute(:user_id) }
  it { should have_readonly_attribute(:order_id) }
  it { should have_readonly_attribute(:shipping_address_id) }

  it { should belong_to(:user) }
  it { should belong_to(:order) }
  it { should belong_to(:shipping_address).class_name('Address') }

  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:order) }
  it { should validate_presence_of(:shipping_address) }

  it { should ensure_inclusion_of(:item_type).in_array(%w{ PhysicalItem }) }
end
