require 'spec/models/shared/activable'
require 'spec/models/shared/deletable'
require 'spec/models/shared/displayable'
require 'spec/models/shared/fulfillable'

shared_examples 'item resource' do

  it_behaves_like 'activable model'
  it_behaves_like 'deletable model'
  it_behaves_like 'displayable model'
  it_behaves_like 'fulfillable model'

  describe 'factory model' do
    it('is valid') { expect(model.valid?).to be_true }
    it('saves successfully') { expect(model.save).to be_true }
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
        model.deactivate!
        expect(model).to_not be_available
      end
    end
  end
end
