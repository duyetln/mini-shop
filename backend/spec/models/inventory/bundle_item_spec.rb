require "spec_helper"
require "item_resource_helper"

describe BundleItem do

  let(:item_class) { described_class }

  it_behaves_like "item resource"

  it { should have_many(:bundlings).with_foreign_key(:bundle_id) }

  describe "#available?" do

    context "items not present" do

      before :each do
        expect(created_item).to receive(:items).and_return([ ])
      end

      it "is false" do

        expect(created_item).to_not be_available
      end
    end

    context "items present" do

      context "items unavailable" do

        it "is false" do

          created_item.items.sample.send([:delete!, :deactivate!].sample)
          expect(created_item).to_not be_available
        end
      end

      context "items available" do

        it "is true" do
          
          expect(created_item).to be_available
        end
      end
    end
  end

end