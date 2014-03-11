shared_examples "committable object" do

  it { should_not allow_mass_assignment_of(:committed) }
  it { should_not allow_mass_assignment_of(:committed_at) }

  context "class" do
    let(:subject) { described_class }
    it { should respond_to(:committed).with(0).argument }
    it { should respond_to(:pending).with(0).argument }
  end

  context "instance" do
    let(:subject) { described_class.new }
    it { should respond_to(:committed).with(0).argument }
    it { should respond_to(:committed=).with(1).argument }
    it { should respond_to(:committed_at).with(0).argument }
    it { should respond_to(:committed_at=).with(0).argument }
    it { should respond_to(:committed?).with(0).argument }
    it { should respond_to(:pending?).with(0).argument }
    it { should respond_to(:commit!).with(0).argument }
  end

end