require 'models/spec_setup'
require 'spec/models/shared/deletable'
require 'spec/models/shared/displayable'
require 'spec/models/shared/orderable'
require 'spec/models/shared/itemable'

describe StoreItem do

  it_behaves_like 'deletable model'
  it_behaves_like 'displayable model'
  it_behaves_like 'orderable model'
  it_behaves_like 'itemable model'

  include_examples 'default #deletable?'

  it { should belong_to(:item) }
  it { should belong_to(:price) }

  it { should allow_mass_assignment_of(:item_type) }
  it { should allow_mass_assignment_of(:item_id) }
  it { should allow_mass_assignment_of(:price_id) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:price) }
  it { should validate_presence_of(:item) }
  it { should ensure_inclusion_of(:item_type).in_array(%w{ Bundle DigitalItem PhysicalItem }) }

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

  describe '#amount' do
    let(:currency) { model.price.pricepoint.pricepoint_prices.sample.currency }

    it 'delegates to price' do
      expect(model.amount(currency)).to eq(model.price.amount(currency))
    end
  end

  describe '#discounted?' do
    it 'delegates to price' do
      expect(model.discounted?).to eq(model.price.discounted?)
    end
  end
end
