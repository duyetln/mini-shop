require 'spec_helper'
require 'spec/models/shared/item_combinable'
require 'spec/models/shared/deletable'

describe Order do

  it_behaves_like 'item combinable model'
  it_behaves_like 'deletable model'

  it { should_not allow_mass_assignment_of(:uuid) }
  it { should_not allow_mass_assignment_of(:purchase_id) }
  it { should_not allow_mass_assignment_of(:status) }
  it { should_not allow_mass_assignment_of(:fulfilled_at) }
  it { should_not allow_mass_assignment_of(:reversed_at) }

  it { should have_readonly_attribute(:uuid) }
  it { should have_readonly_attribute(:purchase_id) }

  it { should validate_presence_of(:purchase) }
  it { should validate_presence_of(:currency) }

  it("foo") { saved_model.should ensure_inclusion_of(:item_type).in_array(%w{ StorefrontItem }) }

  describe '#user' do
    it 'delegates to #purchase' do
      expect(saved_model.user).to eq(saved_model.purchase.user)
    end
  end

  describe '#payment_method' do
    it 'delegates to #purchase' do
      expect(saved_model.payment_method).to eq(saved_model.purchase.payment_method)
    end
  end

  describe '#billing_address' do
    it 'delegates to #purchase' do
      expect(saved_model.billing_address).to eq(saved_model.purchase.billing_address)
    end
  end

  describe '#shipping_address' do
    it 'delegates to #purchase' do
      expect(saved_model.shipping_address).to eq(saved_model.purchase.shipping_address)
    end
  end

  describe '#purchase_committed?' do
    it 'delegates to #purchase' do
      expect(saved_model.purchase_committed?).to eq(saved_model.purchase.committed?)
    end
  end

  describe '#purchase_pending?' do
    it 'delegates to #purchase' do
      expect(saved_model.purchase_pending?).to eq(saved_model.purchase.pending?)
    end
  end

  describe 'delete!' do
    context 'purchase committed' do
      it 'cannot be executed' do
        saved_model.purchase.commit!
        expect{ saved_model.delete! }.to_not change{ saved_model.deleted? }
      end
    end
  end
end
