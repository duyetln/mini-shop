require "spec_helper"

[PhysicalItem, DigitalItem, BundleItem, StorefrontItem].each do |model|

  describe model do

    let(:instance) { described_class.new }
    let(:klass) { described_class }

    it("responds to active") { expect(klass).to respond_to(:active) }
    it("responds to inactive") { expect(klass).to respond_to(:inactive) }

    it("responds to active?") { expect(instance).to respond_to(:active?) }
    it("responds to inactive?") { expect(instance).to respond_to(:inactive?) }
    it("responds to activate!") { expect(instance).to respond_to(:activate!) }
    it("responds to deactivate!") { expect(instance).to respond_to(:deactivate!) }
  end
end