require "spec_helper"

[PhysicalItem, DigitalItem, BundleItem, StorefrontItem, Order].each do |model|

  describe model do

    let(:instance) { described_class.new }
    let(:klass) { described_class }

    it("responds to deleted") { expect(klass).to respond_to(:deleted) }
    it("responds to kept") { expect(klass).to respond_to(:kept) }

    it("responds to deleted?") { expect(instance).to respond_to(:deleted?) }
    it("responds to kept?") { expect(instance).to respond_to(:kept?) }
    it("responds to delete!") { expect(instance).to respond_to(:delete!) }
  end
end