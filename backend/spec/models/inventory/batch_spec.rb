require 'models/spec_setup'
require 'spec/models/shared/deletable'
require 'spec/models/shared/activable'

describe Batch do
  it_behaves_like 'deletable model'
  it_behaves_like 'activable model'
  include_examples 'default #activable?'
end

describe Batch do
  it { should belong_to :promotion }

  it { should have_many :coupons }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:promotion) }

  describe '#deletable?' do
    it 'equals itself being inactive and kept' do
      expect(model.deletable?).to eq(model.inactive? && model.kept?)
    end
  end
end
