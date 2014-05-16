shared_examples 'quantifiable model' do

  it { should allow_mass_assignment_of(:qty) }

  it { should validate_presence_of(:qty) }
  it { should validate_numericality_of(:qty).is_greater_than_or_equal_to(0) }

  it { should respond_to(:qty) }
  it { should respond_to(:qty=).with(1).argument }
end
