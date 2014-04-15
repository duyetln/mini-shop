require 'models/spec_setup'
require 'spec/models/shared/item_combinable'

describe Fulfillment do
  let(:model) { described_class.new }

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
