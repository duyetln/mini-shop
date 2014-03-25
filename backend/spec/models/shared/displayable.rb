shared_examples "displayable model" do

  context "instance" do
    let(:subject) { described_class.new }
    it { should respond_to(:title).with(0).argument }
    it { should respond_to(:description).with(0).argument }
  end

end