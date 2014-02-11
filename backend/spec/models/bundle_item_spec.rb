require "spec_helper"
require "item_resource_shared"

describe BundleItem do

  let(:item_class) { described_class }

  it_behaves_like "item resource"

  describe "factory model" do

    it("has physical items") { expect(built_item.physical_items).to be_present }
    it("has digital items")  { expect(built_item.digital_items).to  be_present }
    it("has bundled items")  { expect(built_item.bundled_items).to  be_present }
  end

  before :each do
    @bundled_items  = built_item.bundled_items
    @physical_items = built_item.physical_items
    @digital_items  = built_item.digital_items
  end

  describe "#available?" do

    context "empty bundled items" do

      it "is false" do

        expect(built_item).to receive(:bundled_items).and_return(@bundled_items)
        expect(@bundled_items).to receive(:present?).and_return(false)
        expect(built_item.available?).to be_false
      end
    end

    context "unavailable physical item" do

      it "is false" do

        physical_item = @physical_items.sample
        expect(physical_item).to receive(:available?).and_return(false)
        expect(built_item.available?).to be_false
      end
    end

    context "unavailable digital item" do

      it "is false" do

        digital_item = @digital_items.sample
        expect(digital_item).to receive(:available?).and_return(false)
        expect(built_item.available?).to be_false
      end
    end
  end

end