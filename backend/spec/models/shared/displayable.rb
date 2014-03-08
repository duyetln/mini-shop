shared_examples "displayable object" do

  context "instance" do
    let(:subject) { described_class.new }
    it { should respond_to(:title).with(0).argument }
    it { should respond_to(:title=).with(1).argument }
    it { should respond_to(:description).with(0).argument }
    it { should respond_to(:description=).with(1).argument }
  end

end