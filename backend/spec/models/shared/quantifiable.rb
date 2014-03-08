shared_examples "quantifiable object" do

  it { should allow_mass_assignment_of(:quantity) }

  it { should validate_presence_of(:quantity) }
  it { should validate_numericality_of(:quantity).is_greater_than_or_equal_to(0) }

  it { should respond_to(:quantity) }
  it { should respond_to(:quantity=).with(1).argument }

end