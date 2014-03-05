require "spec_helper"

[Bundling, Order, Ownership, Shipment].each do |model|

  describe model do

    context "class" do
      let(:subject) { described_class }
      it { should respond_to(:add_or_update).with(4).argument }
      it { should respond_to(:get).with(1).argument }
    end

    context "instance" do
      let(:subject) { described_class.new }
      it { should respond_to(:item_type) }
      it { should respond_to(:item_id) }
      it { should respond_to(:item) }
    end
  end
end