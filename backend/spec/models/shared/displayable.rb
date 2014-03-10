shared_examples "displayable object" do

  if ( [:title, :description] - described_class.column_names.map(&:to_sym) ).blank?
    it { should allow_mass_assignment_of(:title) }
    it { should allow_mass_assignment_of(:description) }
  end

  it { should validate_presence_of(:title) }

  context "instance" do
    let(:subject) { described_class.new }
    it { should respond_to(:title).with(0).argument }
    it { should respond_to(:description).with(0).argument }
  end

end