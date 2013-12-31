require "spec_helper"
require "sku_resource_spec"

describe BundleSku do

  let(:sku_class) { described_class }

  it_behaves_like "sku resource"

  context "factory model" do

    it("has physical skus") { expect(built_sku.physical_skus).to be_present }
    it("has digital skus")  { expect(built_sku.digital_skus).to  be_present }
    it("has bundled skus")  { expect(built_sku.bundled_skus).to  be_present }
  end

  before :each do
    @bundled_skus  = built_sku.bundled_skus
    @physical_skus = built_sku.physical_skus
    @digital_skus  = built_sku.digital_skus
  end

  context "#available?" do

    context "empty bundled skus" do

      it "is false" do

        expect(built_sku).to receive(:bundled_skus).and_return(@bundled_skus)
        expect(@bundled_skus).to receive(:present?).and_return(false)
        expect(built_sku.available?).to be_false
      end
    end

    context "unavailable physical sku" do

      it "is false" do

        physical_sku = @physical_skus.sample
        expect(physical_sku).to receive(:available?).and_return(false)
        expect(built_sku.available?).to be_false
      end
    end

    context "unavailable digital sku" do

      it "is false" do

        digital_sku = @digital_skus.sample
        expect(digital_sku).to receive(:available?).and_return(false)
        expect(built_sku.available?).to be_false
      end
    end
  end

end