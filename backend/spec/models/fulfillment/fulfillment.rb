require 'spec/models/shared/itemable'

shared_examples 'fulfillment model' do

  it_behaves_like 'itemable model'

  it { should_not allow_mass_assignment_of(:status) }
  it { should_not allow_mass_assignment_of(:fulfilled_at) }
  it { should_not allow_mass_assignment_of(:reversed_at) }

  it { should have_readonly_attribute(:order_id) }

  it { should belong_to(:order) }

  it { should validate_presence_of(:order) }

  context 'new record' do
    let(:model) { described_class.new }

    it 'defaults to prepared status' do
      expect(model).to be_prepared
      expect(model.fulfilled_at).to be_nil
      expect(model.reversed_at).to be_nil
    end
  end
end
