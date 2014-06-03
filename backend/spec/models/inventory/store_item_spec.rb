require 'models/spec_setup'
require 'spec/models/shared/deletable'
require 'spec/models/shared/displayable'
require 'spec/models/shared/orderable'
require 'spec/models/shared/itemable'
require 'spec/models/shared/priceable'

describe StoreItem do
  it_behaves_like 'deletable model'
  it_behaves_like 'displayable model'
  it_behaves_like 'orderable model'
  it_behaves_like 'itemable model'
  it_behaves_like 'priceable model'
  include_examples 'default #deletable?'
end

describe StoreItem do
  it { should belong_to(:item) }

  it { should allow_mass_assignment_of(:item_type) }
  it { should allow_mass_assignment_of(:item_id) }
  it { should allow_mass_assignment_of(:price_id) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:item) }
  it { should ensure_inclusion_of(:item_type).in_array(%w{ Bundle DigitalItem PhysicalItem }) }

  let(:item) { model.item }

  describe '#available?' do
    it 'delegates to item' do
      expect(model.available?).to eq(item.available?)
    end
  end

  describe '#active?' do
    it 'delegates to item' do
      expect(model.active?).to eq(item.active?)
    end
  end
end
