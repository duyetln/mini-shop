require 'models/spec_setup'
require 'spec/models/shared/item_combinable'
require 'spec/models/shared/deletable'

describe Order do

  it_behaves_like 'item combinable model'
  it_behaves_like 'deletable model'

  it { should_not allow_mass_assignment_of(:uuid) }
  it { should_not allow_mass_assignment_of(:purchase_id) }

  it { should belong_to(:purchase) }
  it { should belong_to(:currency) }
  it { should belong_to(:refund).class_name('Transaction') }
  it { should have_many(:fulfillments) }

  it { should have_readonly_attribute(:uuid) }
  it { should have_readonly_attribute(:purchase_id) }

  it { should validate_presence_of(:purchase) }
  it { should validate_presence_of(:currency) }
  it { should validate_uniqueness_of(:uuid) }

  it { should ensure_inclusion_of(:item_type).in_array(%w{ StorefrontItem }) }

  describe 'fulfillment methods' do
    let :fulfillment do
      FactoryGirl.build [:shipping_fulfillment, :online_fulfillment].sample
    end

    let(:model) { fulfillment.order }

    before :each do
      model.fulfillments << fulfillment
    end

    shared_examples 'does not do anything' do
      it 'does not do anything' do
        expect(model.item).to_not receive(process_method).with(model, model.qty)
        expect(fulfillment).to_not receive(process_method)
        expect(model).to_not receive(mark_method)
        expect(model.send(method)).to be_nil
      end
    end

    shared_examples 'status false' do
      context 'status false' do
        before :each do
          model.stub(status_method).and_return(false)
        end

        include_examples 'does not do anything'
      end
    end

    shared_examples 'purchase pending' do
      context 'purchase pending' do
        before :each do
          model.stub(:purchase_committed?).and_return(false)
        end

        include_examples 'does not do anything'
      end
    end

    describe '#fulfill!!' do
      let(:method) { :fulfill! }
      let(:process_method) { :fulfill! }
      let(:status_method) { :unmarked? }
      let(:check_method) { :fulfilled? }
      let(:mark_method) { :mark_fulfilled! }

      before :each do
        model.stub(:purchase_committed?).and_return(true)
        model.stub(status_method).and_return(true)
        model.item.stub(:prepare!).with(model, model.qty).and_return(true)
        fulfillment.stub(process_method).and_return(true)
      end

      include_examples 'status false'
      include_examples 'purchase pending'

      context 'failed item preparation' do
        before :each do
          model.item.stub(:prepare!).with(model, model.qty).and_return(false)
        end

        it 'marks status and creates refund' do
          expect(model).to_not receive(mark_method)
          expect(model).to receive(:make_refund!)
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
          expect(model).to receive(:make_refund!)
          expect(model).to receive(:mark_failed!)
          expect(model).to receive(:reload)
          expect(model.send(method)).to eq(model.send(check_method))
        end
      end

      it 'marks status and returns' do
        expect(model).to receive(mark_method)
        expect(model).to_not receive(:make_refund!)
        expect(model).to_not receive(:mark_failed!)
        expect(model).to receive(:reload)
        expect(model.send(method)).to eq(model.send(check_method))
      end
    end

    describe '#reverse!' do
      let(:method) { :reverse! }
      let(:process_method) { :reverse! }
      let(:status_method) { :fulfilled? }
      let(:check_method) { :reversed? }
      let(:mark_method) { :mark_reversed! }

      before :each do
        model.stub(:purchase_committed?).and_return(true)
        model.stub(status_method).and_return(true)
        fulfillment.stub(process_method).and_return(true)
      end

      include_examples 'status false'
      include_examples 'purchase pending'

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

      it 'marks status and returns' do
        expect(model).to receive(:make_refund!)
        expect(model).to receive(mark_method)
        expect(model).to_not receive(:mark_failed!)
        expect(model).to receive(:reload)
        expect(model.send(method)).to eq(model.send(check_method))
      end
    end
  end

  describe '#amount!' do
    before :each do
      model.amount!(currency)
    end

    it 'updates the currency' do
      expect(model.currency).to eq(currency)
    end

    it 'updates the amount' do
      expect(model['amount']).to eq(model.item.amount(currency) * model.qty)
    end
  end

  describe 'tax!' do
    before :each do
      model.amount!(currency)
      model.tax!
    end

    it 'sets the tax rate' do
      expect(model.tax_rate).to be_present
    end

    it 'sets the tax amount' do
      expect(model['tax']).to eq(model['amount'] * model.tax_rate)
    end
  end

  describe '#amount' do
    it 'multiplies translated amount with #qty' do
      model.amount!(currency)
      expect(model.amount(currency)).to eq(
        Currency.exchange(model['amount'], model.currency, currency)
      )
    end
  end

  describe '#tax' do
    it 'multiplies translated tax with #tax_rate' do
      model.amount!(currency)
      model.tax!
      expect(model.tax(currency)).to eq(
        Currency.exchange(model['tax'], model.currency, currency)
      )
    end
  end

  describe '#make_refund!' do
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
        expect { model.send(:make_refund!) }.to_not change { model.refund }
      end
    end

    context 'unpaid' do
      before :each do
        model.stub(:purchase_paid?).and_return(false)
      end

      it 'does not do anything' do
        expect { model.send(:make_refund!) }.to_not change { model.refund }
      end
    end

    context 'zero total' do
      before :each do
        model.stub(:total).and_return(0)
      end

      it 'does not do anything' do
        expect { model.send(:make_refund!) }.to_not change { model.refund }
      end
    end

    it 'creates new refund' do
      expect { model.send(:make_refund!) }.to change { model.refund }
      expect(model.refund).to be_present
    end

    it 'sets correct information' do
      model.send(:make_refund!)
      expect(model.refund.user).to eq(model.user)
      expect(model.refund.amount).to eq(-model.total)
      expect(model.refund.currency).to eq(model.currency)
      expect(model.refund.payment_method).to eq(model.payment_method)
      expect(model.refund.billing_address).to eq(model.billing_address)
    end

    it 'does not create a new refund' do
      model.send(:make_refund!)
      expect(model.refund).to eq(model.send(:make_refund!))
    end
  end

  describe '#total' do
    it 'sums #amount and #tax' do
      model.amount!(currency)
      model.tax!
      expect(model.total).to eq(model.amount + model.tax)
    end
  end

  describe '#purchase_paid?' do
    it 'checks the presence of payment' do
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
