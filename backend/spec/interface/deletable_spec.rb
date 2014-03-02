require "spec_helper"

[PhysicalItem, DigitalItem, BundleItem, StorefrontItem, Order].each do |model|

  describe model do

    context "class" do
      let(:it) { described_class }
      it("responds to deleted") { expect(it).to respond_to(:deleted).with(0).argument }
      it("responds to kept") { expect(it).to respond_to(:kept).with(0).argument }
    end

    context "instance" do
      let(:it) { described_class.new }
      it("responds to deleted?") { expect(it).to respond_to(:deleted?).with(0).argument }
      it("responds to kept?") { expect(it).to respond_to(:kept?).with(0).argument }
      it("responds to delete!") { expect(it).to respond_to(:delete!).with(0).argument }
    end
  end
end