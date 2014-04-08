require 'spec_helper'

[PhysicalItem, DigitalItem, BundleItem, StorefrontItem].each do |model|

  describe model do

    context 'instance' do
      let(:subject) { described_class.new }
      it { should respond_to(:prepare!).with(2).argument }
    end
  end
end

[Purchase, Order, Fulfillment, OnlineFulfillment, ShippingFulfillment].each do |model|

  describe model do

    context 'instance' do
      let(:subject) { described_class.new }
      it { should respond_to(:prepare!).with(0).argument }
      it { should respond_to(:fulfill!).with(0).argument }
      it { should respond_to(:reverse!).with(0).argument }
    end
  end
end
