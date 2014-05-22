require 'spec/models/shared/activable'
require 'spec/models/shared/deletable'
require 'spec/models/shared/displayable'
require 'spec/models/shared/fulfillable'

shared_examples 'item resource' do

  it_behaves_like 'activable model'
  it_behaves_like 'deletable model'
  it_behaves_like 'displayable model'
  it_behaves_like 'fulfillable model'

  include_examples 'default #activable?'

  describe '#deletable?' do
    it 'equals #inactive? and #kept?' do
      expect(model.deletable?).to eq(model.inactive? && model.kept?)
    end
  end

  describe '#available?' do
    context 'deleted' do
      it 'is false' do
        model.delete!
        expect(model).to_not be_available
      end
    end

    context 'inactive' do
      it 'is false' do
        model.active = false
        expect(model).to_not be_available
      end
    end
  end
end
