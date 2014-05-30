require 'spec/models/shared/activable'
require 'spec/models/shared/deletable'
require 'spec/models/shared/displayable'
require 'spec/models/shared/fulfillable'

shared_examples 'default item resource #available?' do
  describe '#available?' do
    it 'equals #kept?' do
      expect(model.available?).to eq(model.kept?)
    end
  end
end

shared_examples 'default item resource #activable?' do
  describe '#activable?' do
    it 'equals #available? and #inactive?' do
      expect(model.activable?).to eq(model.available? && model.inactive?)
    end
  end
end

shared_examples 'item resource' do

  it_behaves_like 'activable model'
  it_behaves_like 'deletable model'
  it_behaves_like 'displayable model'
  it_behaves_like 'fulfillable model'

  describe '#deletable?' do
    it 'equals #inactive? and #kept?' do
      expect(model.deletable?).to eq(model.inactive? && model.kept?)
    end
  end
end
