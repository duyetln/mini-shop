require "spec_helper"

[PhysicalItem, DigitalItem, BundleItem, StorefrontItem].each do |model|

  describe model do

    let(:instance) { described_class.new }

    it("responds to fulfill!") { expect(instance).to respond_to(:fulfill!).with(1).argument }
    # it("responds to unfulfill!") { expect(instance).to respond_to(:unfulfill!).with(1).argument }
  end
end

[Purchase, Order].each do |model|

  describe model do

    let(:instance) { described_class.new }

    it("responds to fulfill!") { expect(instance).to respond_to(:fulfill!).with(0).argument }
    # it("responds to unfulfill!") { expect(instance).to respond_to(:unfulfill!).with(0).argument }
  end
end