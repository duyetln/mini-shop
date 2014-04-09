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

  context 'fulfillment methods' do
    let :fulfillment do
      FactoryGirl.build [:shipping_fulfillment, :online_fulfillment].sample
    end

    let(:model) { fulfillment.order }

    before :each do
      model.fulfillments << fulfillment
    end

    describe '#prepare!' do
      before :each do
        expect(model).to receive(:unmarked?).and_return(status)
      end

      context 'unmarked' do
        let(:status) { true }

        before :each do
          expect(model.item).to receive(:prepare!).with(model, model.qty).and_return(item_preparation_status)
        end

        context 'successful item preparation' do
          let(:item_preparation_status) { true }

          before :each do
            expect(fulfillment).to receive(:prepare!).and_return(preparation_status)
          end

          context 'successful preparation' do
            let(:preparation_status) { true }

            it 'changes the status and saves' do
              expect(model).to receive(:mark_prepared!)
              expect(model).to receive(:save!)
              expect(model.prepare!).to be_true
            end
          end

          context 'failed preparation' do
            let(:preparation_status) { false }

            it 'does not change the status or save' do
              expect(model).to_not receive(:mark_prepared!)
              expect(model).to_not receive(:save!)
              expect(model.prepare!).to_not be_true
            end
          end
        end

        context 'failed item preparation' do
          let(:item_preparation_status) { false }

          it 'does not prepare, change status, or save' do
            expect(fulfillment).to_not receive(:prepare!)
            expect(model).to_not receive(:mark_prepared!)
            expect(model).to_not receive(:save!)
            expect(model.prepare!).to_not be_true
          end
        end
      end

      context 'marked' do
        let(:status) { false }

        it 'does not prepare, change status, or save' do
          expect(model.item).to_not receive(:prepare!)
          expect(fulfillment).to_not receive(:prepare!)
          expect(model).to_not receive(:mark_prepared!)
          expect(model).to_not receive(:save!)
          expect(model.prepare!).to_not be_true
        end
      end
    end

    describe '#fulfill!' do
      before :each do
        expect(model).to receive(:prepared?).and_return(status)
      end

      context 'prepared' do
        let(:status) { true }

        before :each do
          expect(fulfillment).to receive(:fulfill!).and_return(fulfillment_status)
        end

        context 'successful fulfillment' do
          let(:fulfillment_status) { true }

          it 'changes the status and saves' do
            expect(model).to receive(:mark_fulfilled!)
            expect(model).to receive(:save!)
            expect(model.fulfill!).to be_true
          end
        end

        context 'failed fulfillment' do
          let(:fulfillment_status) { false }

          it 'does not change the status or save' do
            expect(model).to_not receive(:mark_fulfilled!)
            expect(model).to_not receive(:save!)
            expect(model.fulfill!).to_not be_true
          end
        end
      end

      context 'not prepared' do
        let(:status) { false }

        it 'does not fulfill, change status, or save' do
          expect(fulfillment).to_not receive(:fulfill!)
          expect(model).to_not receive(:mark_fulfilled!)
          expect(model).to_not receive(:save!)
          expect(model.fulfill!).to_not be_true
        end
      end
    end

    describe '#reverse!' do
      before :each do
        expect(model).to receive(:fulfilled?).and_return(status)
      end

      context 'fulfilled' do
        let(:status) { true }

        before :each do
          expect(fulfillment).to receive(:reverse!).and_return(reversal_status)
        end

        context 'successful reversal' do
          let(:reversal_status) { true }

          it 'changes the status and saves' do
            expect(model).to receive(:mark_reversed!)
            expect(model).to receive(:save!)
            expect(model.reverse!).to be_true
          end
        end

        context 'failed reversal' do
          let(:reversal_status) { false }

          it 'does not change the status or save' do
            expect(model).to_not receive(:mark_reversed!)
            expect(model).to_not receive(:save!)
            expect(model.reverse!).to_not be_true
          end
        end
      end

      context 'not fulfilled' do
        let(:status) { false }

        it 'does not reverse, change status, or save' do
          expect(fulfillment).to_not receive(:reverse!)
          expect(model).to_not receive(:mark_reversed!)
          expect(model).to_not receive(:save!)
          expect(model.reverse!).to_not be_true
        end
      end
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
