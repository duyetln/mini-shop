require 'spec_helper'
require 'spec/models/shared/item_combinable'

describe Ownership do

  it_behaves_like "item combinable model"

  it { should have_readonly_attribute(:user_id) }
  it { should have_readonly_attribute(:order_id) }

  it { should belong_to(:user) }
  it { should belong_to(:order) }

  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:order) }

  it { should ensure_inclusion_of(:item_type).in_array(%w{ DigitalItem }) }

end
