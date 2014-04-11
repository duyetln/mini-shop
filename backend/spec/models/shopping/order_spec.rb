require 'spec_helper'
require 'spec/models/shared/item_combinable'
require 'spec/models/shared/deletable'

describe Order do

  it_behaves_like 'item combinable model'
  it_behaves_like 'deletable model'

  it { should_not allow_mass_assignment_of(:uuid) }
  it { should_not allow_mass_assignment_of(:purchase_id) }

  it { should have_readonly_attribute(:uuid) }
  it { should have_readonly_attribute(:purchase_id) }

  it { should validate_presence_of(:purchase) }
  it { should validate_presence_of(:currency) }

  it { should ensure_inclusion_of(:item_type).in_array(%w{ StorefrontItem }) }

  describe 'fulfillment methods' do
    let :fulfillment do
      FactoryGirl.build [:shipping_fulfillment, :online_fulfillment].sample
    end

    let(:model) { fulfillment.order }

    before :each do
      model.fulfillments << fulfillment
    end

    shared_examples 'marks success status and returns' do
      it 'marks status and returns' do
        expect(model).to receive(mark_method)
        expect(model).to_not receive(:mark_failed!)
        expect(model.send(method)).to eq(model.send(check_method))
      end
    end

    shared_examples 'marks failure status and returns' do
      it 'marks status and returns' do
        expect(model).to_not receive(mark_method)
        expect(model).to receive(:mark_failed!)
        expect(model.send(method)).to eq(model.send(check_method))
      end
    end

    shared_examples 'does not do anything' do
      it 'does not do anything' do
        expect(model).to_not receive(mark_method)
        expect(model).to_not receive(:mark_failed!)
        expect(model.send(method)).to be_nil
      end
    end

    shared_examples 'fulfillment method' do
      before :each do
        expect(model).to receive(:purchase_committed?).and_return(committed_status)
      end

      context 'committed purchase' do
        let(:committed_status) { true }

        before :each do
          expect(model).to receive(status_method).and_return(status)
        end

        context 'status true' do
          before :each do
            expect(fulfillment).to receive(process_method).and_return(process_status)
          end

          let(:status) { true }

          context 'successful processing' do
            let(:process_status) { true }

            include_examples 'marks success status and returns'
          end

          context 'failed processing' do
            let(:process_status) { false }

            include_examples 'marks failure status and returns'
          end
        end

        context 'status false' do
          let(:status) { false }

          include_examples 'does not do anything'
        end
      end

      context 'pending purchase' do
        let(:committed_status) { false }

        include_examples 'does not do anything'
      end
    end

    describe '#prepare' do
      let(:method) { :prepare! }
      let(:process_method) { :prepare! }
      let(:status_method) { :unmarked? }
      let(:check_method) { :prepared? }
      let(:mark_method) { :mark_prepared! }

      before :each do
        expect(model).to receive(:purchase_committed?).and_return(committed_status)
      end

      context 'committed purchase' do
        let(:committed_status) { true }

        before :each do
          expect(model).to receive(status_method).and_return(status)
        end

        context 'unmarked' do
          let(:status) { true }

          before :each do
            expect(model.item).to receive(process_method).with(model, model.qty).and_return(item_preparation_status)
          end

          context 'successful item preparation' do
            let(:item_preparation_status) { true }

            before :each do
              expect(fulfillment).to receive(process_method).and_return(preparation_status)
            end

            context 'successful preparation' do
              let(:preparation_status) { true }

              include_examples'marks success status and returns'
            end

            context 'failed preparation' do
              let(:preparation_status) { false }

              include_examples 'marks failure status and returns'
            end
          end

          context 'failed item preparation' do
            let(:item_preparation_status) { false }

            before :each do
              expect(fulfillment).to_not receive(process_method)
            end

            include_examples 'marks failure status and returns'
          end
        end

        context 'marked' do
          let(:status) { false }

          include_examples 'does not do anything'
        end
      end

      context 'pending purchase' do
        let(:committed_status) { false }

        include_examples 'does not do anything'
      end
    end

    describe '#fulfill!' do
      let(:method) { :fulfill! }
      let(:process_method) { :fulfill! }
      let(:status_method) { :prepared? }
      let(:check_method) { :fulfilled? }
      let(:mark_method) { :mark_fulfilled! }

      include_examples 'fulfillment method'
    end

    describe '#reverse!' do
      let(:method) { :reverse! }
      let(:process_method) { :reverse! }
      let(:status_method) { :fulfilled? }
      let(:check_method) { :reversed? }
      let(:mark_method) { :mark_reversed! }

      include_examples 'fulfillment method'
    end
  end

  describe '#save' do
    it 'updates amount, tax_rate, and tax' do
      model.save
      expect(model.amount).to eq(model.item.amount(model.currency) * model.qty)
      expect(model.tax_rate).to be_present
      expect(model.tax).to eq(model.amount * model.tax_rate)
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
