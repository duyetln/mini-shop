require "spec_helper"
require "sku_resource_spec"

describe StorefrontSku do

  include SkuResourceSpec

  before :each do
    @associated_sku = @factory_sku.sku
  end

  context "#available?" do

    context "unavailable sku" do

      it "is false" do

        expect(@factory_sku).to receive(:sku).and_return(@associated_sku)
        expect(@associated_sku).to receive(:available?).and_return(false)
        expect(@factory_sku.available?).to be_false
      end
    end
  end

end