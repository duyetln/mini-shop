require 'spec/models/shared/itemable'

shared_examples 'fulfillment model' do

  it_behaves_like 'itemable model'

  it { should have_readonly_attribute(:order_id) }

  it { should belong_to(:order) }

  it { should validate_presence_of(:order) }

  context 'new record' do
    let(:model) { described_class.new }

    it 'defaults to nil status' do
      expect(model.status).to be_nil
      expect(model).to_not be_prepared
      expect(model).to_not be_fulfilled
      expect(model).to_not be_reversed
    end
  end
end
