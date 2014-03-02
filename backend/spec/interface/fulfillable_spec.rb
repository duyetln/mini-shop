require "spec_helper"

[PhysicalItem, DigitalItem, BundleItem, StorefrontItem].each do |model|

  describe model do

    context "instance" do
      let(:it) { described_class.new }
      it("responds to prepare!") { expect(it).to respond_to(:prepare!).with(1).argument }
    end
  end
end

[Purchase, Order].each do |model|

  describe model do

    context "instance" do
      let(:it) { described_class.new }
      it("responds to prepare!") { expect(it).to respond_to(:prepare!).with(0).argument }
      it("responds to fulfill!") { expect(it).to respond_to(:fulfill!).with(0).argument }
      it("responds to reverse!") { expect(it).to respond_to(:reverse!).with(0).argument }
    end
  end
end

[Fulfillment, OnlineFulfillment, ShippingFulfillment].each do |model|

  describe model do

    context "class" do
      let(:it) { described_class }
      it("responds to prepare!") { expect(it).to respond_to(:prepare!).with(2).argument }
    end

    context "instance" do
      let(:it) { described_class.new }
      it("responds to fulfill!") { expect(it).to respond_to(:fulfill!).with(0).argument }
      it("responds to reverse!") { expect(it).to respond_to(:reverse!).with(0).argument }
    end
  end
end