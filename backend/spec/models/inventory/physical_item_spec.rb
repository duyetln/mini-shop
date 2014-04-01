require 'spec_helper'
require 'spec/models/shared/item_resource'

describe PhysicalItem do

  it_behaves_like 'item resource'

  it { should allow_mass_assignment_of(:qty) }
  it { should validate_presence_of(:qty) }

  it { should validate_numericality_of(:qty).is_greater_than_or_equal_to(0) }

  describe '#available?' do
    context 'zero qty' do
      it 'is false' do
        model.qty = 0
        expect(model).to_not be_available
      end
    end
  end

end
