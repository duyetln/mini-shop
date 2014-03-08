require "spec_helper"
require "spec/models/shared/item_resource"

describe PhysicalItem do

  let(:item_class) { described_class }

  it_behaves_like "item resource"

  it { should allow_mass_assignment_of(:quantity) }
  it { should validate_presence_of(:quantity) }

  it { should validate_numericality_of(:quantity).is_greater_than_or_equal_to(0) }

  describe "#available?" do

    context "zero quantity" do

      it "is false" do

        created_item.quantity = 0
        created_item.save
        expect(created_item).to_not be_available
      end
    end
  end

end