require "spec_helper"

[PhysicalItem, DigitalItem, BundleItem, StorefrontItem].each do |model|

  describe model do

    let(:instance) { described_class.new }

    it("responds to prepare!") { expect(instance).to respond_to(:prepare!).with(1).argument }
  end
end

[Purchase, Order].each do |model|

  describe model do

    let(:instance) { described_class.new }

    it("responds to prepare!") { expect(instance).to respond_to(:prepare!).with(0).argument }
    it("responds to fulfill!") { expect(instance).to respond_to(:fulfill!).with(0).argument }
    it("responds to reverse!") { expect(instance).to respond_to(:reverse!).with(0).argument }
  end
end

[Fulfillment, OnlineFulfillment, ShippingFulfillment].each do |model|

  describe model do

    let(:instance) { described_class.new }
    let(:klass) { described_class }

    it("responds to prepare!") { expect(klass).to respond_to(:prepare!).with(2).argument }
    it("responds to fulfill!") { expect(instance).to respond_to(:fulfill!).with(0).argument }
    it("responds to reverse!") { expect(instance).to respond_to(:reverse!).with(0).argument }
  end
end