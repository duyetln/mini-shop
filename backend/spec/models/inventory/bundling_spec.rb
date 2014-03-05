require "spec_helper"

describe Bundling do

  it { should validate_presence_of(:bundle) }
  it { should validate_presence_of(:item) }
  it { should validate_presence_of(:quantity) }

  # shoulda-matcher doesn't work well with multiple-field uniqueness scope
  # it do
  #   bundling = Bundling.new
  #   bundling.bundle  = FactoryGirl.create :bundle_item
  #   bundling.item = FactoryGirl.create :digital_item
  #   bundling.quantity = 1
  #   bundling.save!

  #   should validate_uniqueness_of(:bundle_id).scoped_to([ :item_id, :item_type ] ) 
  # end

  it { should ensure_inclusion_of(:item_type).in_array(%w{ DigitalItem PhysicalItem }) }
  it { should validate_numericality_of(:quantity).is_greater_than_or_equal_to(0) }

end