require 'models/spec_setup'
require 'spec/models/shared/item_combinable'
require 'spec/models/shared/deletable'

describe Order do
  it_behaves_like 'item combinable model'
  it_behaves_like 'deletable model'
end

describe Order do
  it { should_not allow_mass_assignment_of(:uuid) }
  it { should_not allow_mass_assignment_of(:purchase_id) }

  it { should belong_to(:purchase).inverse_of(:orders) }
  it { should belong_to(:currency) }
  it { should belong_to(:refund).class_name('Transaction') }
  it { should have_many(:fulfillments).inverse_of(:order) }

  it { should have_readonly_attribute(:uuid) }
  it { should have_readonly_attribute(:purchase_id) }

  it { should validate_presence_of(:purchase) }
  it { should validate_presence_of(:currency) }
  it { should validate_presence_of(:amount) }

  it { should ensure_inclusion_of(:item_type).in_array(%w{ Coupon Bundle DigitalItem PhysicalItem }) }

  describe '.for_user' do
    before :each do
      model.save!
    end

    it 'returns orders of a user' do
      expect(described_class.for_user(model.purchase.user.id)).to include(model)
    end
  end

  context 'uniqueness validation' do
    let :subject do
      model.save!
      model
    end

    it { should validate_uniqueness_of(:uuid) }
  end

  describe '#deletable?' do
    it 'equals #purchase_pending? and #kept?' do
      expect(model.deletable?).to eq(model.purchase_pending? && model.kept?)
    end
  end

  describe '#fulfillable?' do
    it 'equals #purchase_committed and #unmarked? and active item and available item' do
      expect(model.fulfillable?).to eq(model.purchase_committed? && model.unmarked? && model.item.active? && item.available?)
    end
  end

  describe '#reversible?' do
    it 'equals #purchase_committed and #fulfilled? and active item' do
      expect(model.fulfillable?).to eq(model.purchase_committed? && model.fulfilled? && model.item.active?)
    end
  end

  describe 'fulfillment methods' do
    let :fulfillment do
      FactoryGirl.build [:shipping_fulfillment, :online_fulfillment].sample
    end

    let(:model) { fulfillment.order }

    before :each do
      model.fulfillments << fulfillment
    end

    shared_examples 'status not ready' do
      context 'status not ready' do
        before :each do
          model.stub(status_method).and_return(false)
        end

        it 'does nothing' do
          expect(model.item).to_not receive(process_method).with(model, model.qty)
          expect(fulfillment).to_not receive(process_method)
          expect(model).to_not receive(mark_method)
          expect(model.send(method)).to be_nil
        end
      end
    end

    describe '#fulfill!!' do
      let(:method) { :fulfill! }
      let(:process_method) { :fulfill! }
      let(:status_method) { :fulfillable? }
      let(:check_method) { :fulfilled? }
      let(:mark_method) { :mark_fulfilled! }

      before :each do
        model.stub(status_method).and_return(true)
        model.item.stub(process_method).with(model, model.qty).and_return(true)
        fulfillment.stub(process_method).and_return(true)
      end

      include_examples 'status not ready'

      context 'failed item fulfillment' do
        before :each do
          model.item.stub(process_method).with(model, model.qty).and_return(false)
        end

        it 'marks status and creates refund' do
          expect(model).to_not receive(mark_method)
          expect(model).to receive(:refund!)
          expect(model).to receive(:mark_failed!)
          expect(model).to receive(:reload)
          expect(model.send(method)).to eq(model.send(check_method))
        end
      end

      context 'failed fufillment' do
        before :each do
          fulfillment.stub(process_method).and_return(false)
        end

        it 'marks status and creates refund' do
          expect(model).to_not receive(mark_method)
          expect(model).to receive(:refund!)
          expect(model).to receive(:mark_failed!)
          expect(model).to receive(:reload)
          expect(model.send(method)).to eq(model.send(check_method))
        end
      end

      it 'marks status and returns' do
        expect(model).to receive(mark_method)
        expect(model).to_not receive(:refund!)
        expect(model).to_not receive(:mark_failed!)
        expect(model).to receive(:reload)
        expect(model.send(method)).to eq(model.send(check_method))
      end
    end

    describe '#reverse!' do
      let(:method) { :reverse! }
      let(:process_method) { :reverse! }
      let(:status_method) { :reversible? }
      let(:check_method) { :reversed? }
      let(:mark_method) { :mark_reversed! }

      before :each do
        model.stub(status_method).and_return(true)
        model.item.stub(process_method).with(model).and_return(true)
        fulfillment.stub(process_method).and_return(true)
      end

      include_examples 'status not ready'

      context 'failed reversal' do
        before :each do
          fulfillment.stub(process_method).and_return(false)
        end

        it 'marks status and returns' do
          expect(model).to_not receive(mark_method)
          expect(model).to receive(:mark_failed!)
          expect(model).to receive(:reload)
          expect(model.send(method)).to eq(model.send(check_method))
        end
      end

      context 'failed item fulfillment' do
        before :each do
          model.item.stub(process_method).with(model).and_return(false)
        end

        it 'marks status and returns' do
          expect(model).to_not receive(mark_method)
          expect(model).to receive(:mark_failed!)
          expect(model).to receive(:reload)
          expect(model.send(method)).to eq(model.send(check_method))
        end
      end

      it 'marks status and creates refund' do
        expect(model).to receive(:refund!)
        expect(model).to receive(mark_method)
        expect(model).to_not receive(:mark_failed!)
        expect(model).to receive(:reload)
        expect(model.send(method)).to eq(model.send(check_method))
      end
    end
  end

  describe '#update_amount_and_tax' do
    shared_examples 'sets tax and tax rate' do
      it 'sets tax and tax rate' do
        model.currency = new_currency
        model.save!
        expect(model['tax']).to be_present
        expect(model['tax_rate']).to be_present
      end
    end

    before :each do
      expect(model).to_not be_persisted
      expect(model['tax_rate']).to be_nil
      expect(model['tax']).to be_nil
    end

    context 'new' do
      let(:new_currency) { model.currency }
      it 'does not change amount' do
        model.currency = new_currency
        expect { model.save! }.to_not change { model['amount'] }
      end

      include_examples 'sets tax and tax rate'
    end

    context 'persisted' do
      before :each do
        model.save!
      end

      context 'currency id changed' do
        let(:new_currency) { FactoryGirl.build :eur }

        before :each do
          expect(new_currency).to_not eq(model.currency)
        end

        it 'updates amount' do
          old_currency = model.currency
          old_amount = model['amount']

          model.currency = new_currency
          expect { model.save! }.to change { model['amount'] }.to(
            Currency.exchange(old_amount, old_currency, new_currency)
          )
        end

        include_examples'sets tax and tax rate'
      end

      context 'currency id unchanged' do
        let(:new_currency) { model.currency }

        it 'does not update amount' do
          old_currency = model.currency
          old_amount = model['amount']

          model.currency = new_currency
          expect { model.save! }.to_not change { model['amount'] }
        end

        include_examples 'sets tax and tax rate'
      end
    end
  end

  describe '#refund!' do
    before :each do
      model.save!
      model.purchase.commit!
      model.stub(:purchase_committed?).and_return(true)
      model.stub(:purchase_paid?).and_return(true)
      model.stub(:total).and_return(amount)
    end

    context 'purchase pending' do
      before :each do
        model.stub(:purchase_committed?).and_return(false)
      end

      it 'does not do anything' do
        expect { model.send(:refund!) }.to_not change { model.refund }
      end
    end

    context 'unpaid' do
      before :each do
        model.stub(:purchase_paid?).and_return(false)
      end

      it 'does not do anything' do
        expect { model.send(:refund!) }.to_not change { model.refund }
      end
    end

    context 'zero total' do
      before :each do
        model.stub(:total).and_return(0)
      end

      it 'does not do anything' do
        expect { model.send(:refund!) }.to_not change { model.refund }
      end
    end

    it 'creates new refund' do
      expect { model.send(:refund!) }.to change { model.refund }
      expect(model.refund).to be_present
    end

    it 'sets correct information' do
      model.send(:refund!)
      expect(model.refund.user).to eq(model.user)
      expect(model.refund.amount).to eq(-model.total)
      expect(model.refund.currency).to eq(model.currency)
      expect(model.refund.payment_method).to eq(model.payment_method)
      expect(model.refund.billing_address).to eq(model.billing_address)
    end

    it 'does not create a new refund' do
      model.send(:refund!)
      expect(model.refund).to eq(model.send(:refund!))
    end
  end

  describe '#purchase_free?' do
    it 'delegates to #purchase' do
      expect(model.purchase_free?).to eq(model.purchase.free?)
    end
  end

  describe '#purchase_paid?' do
    it 'delegates to #purchase' do
      expect(model.purchase_paid?).to eq(model.purchase.paid?)
    end
  end

  describe '#purchase_payment' do
    it 'delegates to #purchase' do
      expect(model.purchase_payment).to eq(model.purchase.payment)
    end
  end

  describe '#user' do
    it 'delegates to #purchase' do
      expect(model.user).to eq(model.purchase.user)
    end
  end

  describe '#payment_method' do
    it 'delegates to #purchase' do
      expect(model.payment_method).to eq(model.purchase.payment_method)
    end
  end

  describe '#billing_address' do
    it 'delegates to #purchase' do
      expect(model.billing_address).to eq(model.purchase.billing_address)
    end
  end

  describe '#shipping_address' do
    it 'delegates to #purchase' do
      expect(model.shipping_address).to eq(model.purchase.shipping_address)
    end
  end

  describe '#purchase_committed?' do
    it 'delegates to #purchase' do
      expect(model.purchase_committed?).to eq(model.purchase.committed?)
    end
  end

  describe '#purchase_pending?' do
    it 'delegates to #purchase' do
      expect(model.purchase_pending?).to eq(model.purchase.pending?)
    end
  end

  describe 'delete!' do
    context 'purchase committed' do
      it 'cannot be executed' do
        model.purchase.commit!
        expect { model.delete! }.to_not change { model.deleted? }
      end
    end
  end
end
