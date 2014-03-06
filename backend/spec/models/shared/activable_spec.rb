require "spec_helper"

[PhysicalItem, DigitalItem, BundleItem, StorefrontItem].each do |model|

  describe model do

    context "class" do
      let(:subject) { described_class }
      it { should respond_to(:active).with(0).argument }
      it { should respond_to(:inactive).with(0).argument }
    end

    context "instance" do
      let(:subject) { described_class.new }
      it { should respond_to(:active?).with(0).argument }
      it { should respond_to(:inactive?).with(0).argument }
      it { should respond_to(:activate!).with(0).argument }
      it { should respond_to(:deactivate!).with(0).argument }
    end
  end
end