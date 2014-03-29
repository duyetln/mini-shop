require 'spec_helper'
require 'spec/models/shared/item_resource'

describe PhysicalItem do

  let(:item_class) { described_class }

  it_behaves_like 'item resource'

  it { should allow_mass_assignment_of(:quantity) }
  it { should validate_presence_of(:quantity) }

  it { should validate_numericality_of(:quantity).is_greater_than_or_equal_to(0) }

  describe '#available?' do

    context 'zero quantity' do
      it 'is false' do
        saved_model.quantity = 0
        saved_model.save
        expect(saved_model).to_not be_available
      end
    end
  end

end
