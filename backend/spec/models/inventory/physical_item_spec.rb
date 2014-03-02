require "spec_helper"
require "item_resource_helper"

describe PhysicalItem do

  let(:item_class) { described_class }

  it_behaves_like "item resource"

  describe("accessible attributes") { it("includes quantity") { expect(attributes).to include(:quantity) } }

  describe "#quantity" do

    context "emtpy" do

      it "is not valid" do

        built_item.quantity = nil
        expect(built_item).to_not be_valid
        expect(built_item.errors).to have_key(:quantity)
      end
    end

    context "negative value" do

      it "is not valid" do

        built_item.quantity = -5
        expect(built_item).to_not be_valid
        expect(built_item.errors).to have_key(:quantity)
      end
    end
  end

  describe "#available?" do

    context "negative quantity" do

      it "is false" do

        built_item.quantity = -5
        expect(built_item).to_not be_available
      end
    end
  end

end