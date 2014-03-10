shared_examples "displayable object" do

  it { should allow_mass_assignment_of(:title) }
  it { should allow_mass_assignment_of(:description) }

  it { should validate_presence_of(:title) }

  context "instance" do
    let(:subject) { described_class.new }
    it { should respond_to(:title).with(0).argument }
    it { should respond_to(:title=).with(1).argument }
    it { should respond_to(:description).with(0).argument }
    it { should respond_to(:description=).with(1).argument }
  end

end