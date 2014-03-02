require "spec_helper"

[Payment, Purchase].each do |model|

  describe model do

    context "class" do
      let(:it) { described_class }
      it("responds to committed") { expect(it).to respond_to(:committed).with(0).argument }
      it("responds to pending") { expect(it).to respond_to(:pending).with(0).argument }
    end

    context "instance" do
      let(:it) { described_class.new }
      it("responds to committed?") { expect(it).to respond_to(:committed?).with(0).argument }
      it("responds to pending?") { expect(it).to respond_to(:pending?).with(0).argument }
      it("responds to commit!") { expect(it).to respond_to(:commit!).with(0).argument }
    end
  end
end