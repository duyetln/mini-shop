require "spec_helper"
require "sku_resource_shared"

describe PhysicalSku do

  let(:sku_class) { described_class }

  it_behaves_like "sku resource"

  describe("accessible attributes") { it("includes quantity") { expect(attributes).to include(:quantity) } }

  describe "#quantity" do

    context "emtpy" do

      it "is not valid" do

        built_sku.quantity = nil
        expect(built_sku.valid?).to be_false
        expect(built_sku.errors).to have_key(:quantity)
      end
    end

    context "negative value" do

      it "is not valid" do

        built_sku.quantity = -5
        expect(built_sku.valid?).to be_false
        expect(built_sku.errors).to have_key(:quantity)
      end
    end
  end

  describe "#available?" do

    context "negative quantity" do

      it "is false" do

        built_sku.quantity = -5
        expect(built_sku.available?).to be_false
      end
    end
  end

end