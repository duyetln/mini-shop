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

end