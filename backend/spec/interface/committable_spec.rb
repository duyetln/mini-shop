require "spec_helper"

[Payment, Purchase].each do |model|

  describe model do

    context "class" do
      let(:subject) { described_class }
      it { should respond_to(:committed).with(0).argument }
      it { should respond_to(:pending).with(0).argument }
    end

    context "instance" do
      let(:subject) { described_class.new }
      it { should respond_to(:committed?).with(0).argument }
      it { should respond_to(:pending?).with(0).argument }
      it { should respond_to(:commit!).with(0).argument }
    end
  end
end