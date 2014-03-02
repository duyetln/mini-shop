require "spec_helper"

[StorefrontItem].each do |model|

  describe model do

    context "instance" do
      let(:it) { described_class.new }
      it("responds to amount") { expect(it).to respond_to(:amount).with(1).argument }
      it("responds to item") { expect(it).to respond_to(:item).with(0).argument }
    end
  end
end