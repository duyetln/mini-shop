require "spec_helper"

[PhysicalItem, DigitalItem, BundleItem, StorefrontItem].each do |model|

  describe model do

    context "class" do
      let(:it) { described_class }
      it("responds to active") { expect(it).to respond_to(:active).with(0).argument }
      it("responds to inactive") { expect(it).to respond_to(:inactive).with(0).argument }
    end

    context "instance" do
      let(:it) { described_class.new }
      it("responds to active?") { expect(it).to respond_to(:active?).with(0).argument }
      it("responds to inactive?") { expect(it).to respond_to(:inactive?).with(0).argument }
      it("responds to activate!") { expect(it).to respond_to(:activate!).with(0).argument }
      it("responds to deactivate!") { expect(it).to respond_to(:deactivate!).with(0).argument }
    end
  end
end