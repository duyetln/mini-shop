require "spec_helper"
require "item_resource_helper"

describe BundleItem do

  let(:item_class) { described_class }

  it_behaves_like "item resource"

  describe "#available?" do

    context "items not present" do

      it "is false" do

        expect(created_item.items).to_not be_present
        expect(created_item).to_not be_available
      end
    end

    context "items present" do

      let(:item) { FactoryGirl.create [:physical_item, :digital_item].sample }

      before :each do
        created_item.add_or_update(item)
      end

      context "items unavailable" do

        it "is false" do

          item.send([ :deactivate!, :delete! ].sample)
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