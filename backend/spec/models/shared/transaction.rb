require 'models/spec_setup'
require 'spec/models/shared/committable'

shared_examples 'transaction model' do
  it_behaves_like 'committable model'
  include_examples 'default #committable?'

  it { should belong_to(:payment_method).inverse_of(:transactions) }
  it { should belong_to(:user).inverse_of(:transactions) }
  it { should belong_to(:currency) }

  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:payment_method) }
  it { should validate_presence_of(:currency) }
  it { should validate_presence_of(:amount) }
  it { should validate_uniqueness_of(:uuid) }

  it { should_not allow_mass_assignment_of(:uuid) }
  it { should have_readonly_attribute(:uuid) }
  it { should have_readonly_attribute(:user_id) }
  it { should have_readonly_attribute(:payment_method_id) }
  it { should have_readonly_attribute(:amount) }
  it { should have_readonly_attribute(:currency_id) }

  describe '#payment_method_currency' do
    it 'delegates to #payment_method' do
      expect(model.payment_method_currency).to eq(model.payment_method.currency)
    end
  end

  describe '#uuid' do
    context 'new payment' do
      it 'is present' do
        expect(model.uuid).to be_present
      end
    end

    context 'saved payment' do
      it 'is present' do
        model.save!
        expect(model.uuid).to be_present
      end
    end
  end
end
