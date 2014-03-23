require "spec_helper"
require "spec/models/shared/item_resource"

describe BundleItem do

  let(:item_class) { described_class }

  it_behaves_like "item resource"

  it { should have_many(:bundlings).with_foreign_key(:bundle_id) }

  describe "#available?" do

    context "items not present" do

      before :each do
        expect(saved_model).to receive(:items).and_return([ ])
      end

      it "is false" do

        expect(saved_model).to_not be_available
      end
    end

    context "items present" do

      context "items unavailable" do

        it "is false" do

          saved_model.items.sample.send([:delete!, :deactivate!].sample)
          expect(saved_model).to_not be_available
        end
      end

      context "items available" do

        it "is true" do
          
          expect(saved_model).to be_available
        end
      end
    end
  end

end