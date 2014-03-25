shared_examples "itemable model" do

  it { should allow_mass_assignment_of(:item_type) }
  it { should allow_mass_assignment_of(:item_id) }

  it { should have_readonly_attribute(:item_type) }
  it { should have_readonly_attribute(:item_id) }

  it { should belong_to(:item) }
  it { should validate_presence_of(:item) }

  it { should respond_to(:item).with(0).argument }
  it { should respond_to(:item_type).with(0).argument }
  it { should respond_to(:item_id).with(0).argument }
  it { should respond_to(:item=).with(1).argument }
  it { should respond_to(:item_type=).with(1).argument }
  it { should respond_to(:item_id=).with(1).argument }

end