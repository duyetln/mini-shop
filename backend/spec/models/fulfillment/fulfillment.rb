require 'spec/models/shared/item_combinable'

describe Fulfillment do
  let(:model) { described_class.new }

  describe '#process_preparation!' do
    it 'defaults to true' do
      expect(model.send(:process_preparation!)).to be_true
    end
  end

  describe '#process_fulfillment!' do
    it 'has no implementation' do
      expect { model.send(:process_fulfillment!) }.to raise_error
    end
  end

  describe '#process_reversal!' do
    it 'has no implementation' do
      expect { model.send(:process_reversal!) }.to raise_error
    end
  end
end

shared_examples 'fulfillment model' do

  it_behaves_like 'item combinable model'

  it { should have_readonly_attribute(:order_id) }

  it { should belong_to(:order) }

  it { should validate_presence_of(:order) }

  it { should respond_to(:prepare!).with(0).argument }
  it { should respond_to(:fulfill!).with(0).argument }
  it { should respond_to(:reverse!).with(0).argument }

  context 'new record' do
    let(:model) { described_class.new }

    it 'defaults to nil status' do
      expect(model).to_not be_marked
      expect(model).to_not be_prepared
      expect(model).to_not be_fulfilled
      expect(model).to_not be_reversed
    end
  end

  shared_examples 'fulfillment method' do
    before :each do
      expect(model).to receive(status_method).and_return(status)
    end

    context 'status true' do
      before :each do
        expect(model).to receive(process_method).and_return(process_status)
      end

      let(:status) { true }

      context 'successful processing' do
        let(:process_status) { true }

        it 'marks status and saves' do
          expect(model).to receive(mark_method)
          expect(model).to receive(:save!)
          model.send(method)
        end
      end

      context 'failed processing' do
        let(:process_status) { false }

        it 'does not do anything' do
          expect(model).to_not receive(mark_method)
          expect(model).to_not receive(:save!)
          model.send(method)
        end
      end
    end

    context 'status false' do
      let(:status) { false }

      it 'does not do anything' do
        expect(model).to_not receive(mark_method)
        expect(model).to_not receive(:save!)
        model.send(method)
      end
    end
  end

  describe '#prepare' do
    let(:method) { :prepare! }
    let(:process_method) { :process_preparation! }
    let(:status_method) { :unmarked? }
    let(:mark_method) { :mark_prepared! }

    include_examples 'fulfillment method'
  end

  describe '#fulfill!' do
    let(:method) { :fulfill! }
    let(:process_method) { :process_fulfillment! }
    let(:status_method) { :prepared? }
    let(:mark_method) { :mark_fulfilled! }

    include_examples 'fulfillment method'
  end

  describe '#reverse!' do
    let(:method) { :reverse! }
    let(:process_method) { :process_reversal! }
    let(:status_method) { :fulfilled? }
    let(:mark_method) { :mark_reversed! }

    include_examples 'fulfillment method'
  end
end
