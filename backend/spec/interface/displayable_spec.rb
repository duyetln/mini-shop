require "spec_helper"

[PhysicalItem, DigitalItem, BundleItem, StorefrontItem].each do |model|

  describe model do

    let(:instance) { described_class.new }

    it("responds to title") { expect(instance).to respond_to(:title) }
    it("responds to description") { expect(instance).to respond_to(:description) }
  end
end