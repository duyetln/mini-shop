require 'models/spec_setup'
require 'spec/models/shared/item_combinable'

describe Fulfillment do
  let(:model) { described_class.new }

  describe '#fulfillable?' do
    it 'equals #unmarked?' do
      expect(model.fulfillable?).to eq(model.unmarked?)
    end
  end

  describe '#reversible?' do
    it 'equals #fulfilled?' do
      expect(model.reversible?).to eq(model.fulfilled?)
    end
  end

  describe '#process_fulfillment!' do
    it 'has no implementation' do
      expect { model.send(:process_fulfillment!) }.to raise_error
    end
  end

  describe '#process_reversal!' do
    it 'has no implementation' do
      expect { model.send(:process_reversal!) }.to raise_error
    end
  end
end
