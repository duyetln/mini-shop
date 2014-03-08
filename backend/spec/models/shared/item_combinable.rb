require "spec/models/shared/itemable"
require "spec/models/shared/quantifiable"

shared_examples "item combinable object" do

  it_behaves_like "itemable object"
  it_behaves_like "quantifiable object"

  context "class" do
    let(:subject) { described_class }
    it { should respond_to(:add_or_update).with(4).argument }
    it { should respond_to(:get).with(1).argument }
  end

end