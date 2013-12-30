require "spec_helper"
require "sku_resource_spec"

describe PhysicalSku do

  include SkuResourceSpec

  context "accessible attributes" do

    before(:each) { @attributes = described_class.accessible_attributes.to_a.map(&:to_sym) }
    
    it("includes quantity") { expect(@attributes).to include(:quantity) }
  end

  context "#quantity" do

    context "emtpy" do

      it "is not valid" do

        @factory_sku.quantity = nil
        expect(@factory_sku.valid?).to be_false
        expect(@factory_sku.errors).to have_key(:quantity)
      end
    end

    context "negative value" do

      it "is not valid" do

        @factory_sku.quantity = -5
        expect(@factory_sku.valid?).to be_false
        expect(@factory_sku.errors).to have_key(:quantity)
      end
    end
  end

  context "#available?" do

    context "negative quantity" do

      it "is false" do

        @factory_sku.quantity = -5
        expect(@factory_sku.available?).to be_false
      end
    end
  end

end