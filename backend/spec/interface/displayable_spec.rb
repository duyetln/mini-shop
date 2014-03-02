require "spec_helper"

[PhysicalItem, DigitalItem, BundleItem, StorefrontItem].each do |model|

  describe model do

    context "instance" do
      let(:it) { described_class.new }
      it("responds to title") { expect(it).to respond_to(:title).with(0).argument }
      it("responds to description") { expect(it).to respond_to(:description).with(0).argument }
    end
  end
end