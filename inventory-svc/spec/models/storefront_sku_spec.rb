require "spec_helper"
require "sku_resource_shared"

describe StorefrontSku do

  let(:sku_class) { described_class }

  it_behaves_like "sku resource"

  before(:each) { @associated_sku = built_sku.sku }

  context "#available?" do

    context "unavailable sku" do

      it "is false" do

        expect(built_sku).to receive(:sku).and_return(@associated_sku)
        expect(@associated_sku).to receive(:available?).and_return(false)
        expect(built_sku.available?).to be_false
      end
    end
  end

end