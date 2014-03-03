require "spec_helper"
require "item_resource_helper"

describe StorefrontItem do

  let(:item_class) { described_class }

  it_behaves_like "item resource"

  before(:each) { @associated_item = built_item.item }

  describe "#available?" do

    context "unavailable item" do

      it "is false" do

        expect(built_item).to receive(:item).and_return(@associated_item)
        expect(@associated_item).to receive(:available?).and_return(false)
        expect(built_item.available?).to be_false
      end
    end
  end

  describe "#amount" do

    let(:currency) { built_item.price.pricepoint.currencies.sample }

    it "delegates to Price#amount" do

      expect(built_item.amount(currency)).to eq(built_item.price.amount(currency))
    end
  end

  describe "#discounted?" do

    it "delegates to Price#discounted?" do

      expect(built_item.discounted?).to eq(built_item.price.discounted?)
    end
  end

end