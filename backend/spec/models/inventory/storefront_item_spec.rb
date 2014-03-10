require "spec_helper"
require "spec/models/shared/item_resource"

describe StorefrontItem do

  let(:item_class) { described_class }

  it_behaves_like "item resource"

  it { should belong_to(:item) }
  it { should belong_to(:price) }

  it { should allow_mass_assignment_of(:item_type) }
  it { should allow_mass_assignment_of(:item_id) }
  it { should allow_mass_assignment_of(:price_id) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:price) }
  it { should validate_presence_of(:item) }
  it { should ensure_inclusion_of(:item_type).in_array(%w{ BundleItem DigitalItem PhysicalItem }) }


  describe "#available?" do

    let(:item) { FactoryGirl.create [:bundle_item, :physical_item, :digital_item].sample }

    before :each do
      expect(created_item).to receive(:item).and_return(item)
    end

    context "item unavailable" do

      it "is false" do

        expect(item).to receive(:available?).and_return(false)
        expect(created_item).to_not be_available
      end
    end

    context "item available" do

      it "is true" do

        expect(item).to receive(:available?).and_return(true)
        expect(created_item).to be_available
      end
    end
  end

  describe "#amount" do

    let(:currency) { new_item.price.pricepoint.currencies.sample }

    it "delegates to Price#amount" do

      expect(new_item.amount(currency)).to eq(new_item.price.amount(currency))
    end
  end

  describe "#discounted?" do

    it "delegates to Price#discounted?" do

      expect(new_item.discounted?).to eq(new_item.price.discounted?)
    end
  end

end