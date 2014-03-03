require "spec_helper"

[PhysicalItem, DigitalItem, BundleItem, StorefrontItem, Order].each do |model|

  describe model do

    context "class" do
      let(:subject) { described_class }
      it { should respond_to(:deleted).with(0).argument }
      it { should respond_to(:kept).with(0).argument }
    end

    context "instance" do
      let(:subject) { described_class.new }
      it { should respond_to(:deleted?).with(0).argument }
      it { should respond_to(:kept?).with(0).argument }
      it { should respond_to(:delete!).with(0).argument }
    end
  end
end