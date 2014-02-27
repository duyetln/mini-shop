require "spec_helper"

[StorefrontItem].each do |model|

  describe model do

    let(:instance) { described_class.new }

    it("responds to amount") { expect(instance).to respond_to(:amount).with(1).argument }
    it("responds to item") { expect(instance).to respond_to(:item) }
  end
end