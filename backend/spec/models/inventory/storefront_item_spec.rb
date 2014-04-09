require 'spec_helper'
require 'spec/models/shared/item_resource'
require 'spec/models/shared/orderable'
require 'spec/models/shared/itemable'

describe StorefrontItem do

  it_behaves_like 'item resource'
  it_behaves_like 'orderable model'
  it_behaves_like 'itemable model'

  it { should belong_to(:item) }
  it { should belong_to(:price) }

  it { should allow_mass_assignment_of(:item_type) }
  it { should allow_mass_assignment_of(:item_id) }
  it { should allow_mass_assignment_of(:price_id) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:price) }
  it { should validate_presence_of(:item) }
  it { should ensure_inclusion_of(:item_type).in_array(%w{ BundleItem DigitalItem PhysicalItem }) }

  describe '#available?' do
    context 'item unavailable' do
      it 'is false' do
        expect(model.item).to receive(:available?).and_return(false)
        expect(model).to_not be_available
      end
    end

    context 'item available' do
      it 'is true' do
        expect(model.item).to receive(:available?).and_return(true)
        expect(model).to be_available
      end
    end
  end

  describe '#amount' do
    let(:currency) { model.price.pricepoint.pricepoint_prices.sample.currency }

    it 'delegates to Price#amount' do
      expect(model.amount(currency)).to eq(model.price.amount(currency))
    end
  end

  describe '#discounted?' do
    it 'delegates to Price#discounted?' do
      expect(model.discounted?).to eq(model.price.discounted?)
    end
  end

end
