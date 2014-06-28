require 'models/spec_setup'
require 'spec/models/shared/displayable'
require 'spec/models/shared/orderable'

describe Coupon do
  it_behaves_like 'displayable model'
  it_behaves_like 'orderable model'
end

describe Coupon do
  context 'class' do
    let(:subject) { described_class }

    it { should respond_to(:used) }
    it { should respond_to(:unused) }
  end

  it { should belong_to(:batch) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:batch) }
  it { should validate_uniqueness_of(:code) }

  context 'new model' do
    it 'correctly sets code, used, used_by, and used_at' do
      expect(model).to_not be_persisted
      expect(model.code).to be_present
      expect(model).to_not be_used
      expect(model.used_by).to be_nil
      expect(model.used_at).to be_nil
    end
  end

  describe '#active?' do
    it 'equals both batch and promotion being active' do
      expect(model.active?).to eq(model.batch.try(:active?) && model.promotion.try(:active?))
    end
  end

  describe '#inactive?' do
    it 'opposites #active' do
      expect(model.inactive?).to eq(!model.active?)
    end
  end

  describe '#deleted?' do
    it 'equals either batch or promotion being deleted' do
      expect(model.deleted?).to eq(
        model.batch.blank? || model.batch.deleted? || model.promotion.blank? || model.promotion.deleted?
      )
    end
  end

  describe '#kept?' do
    it 'opposites #deleted?' do
      expect(model.kept?).to eq(!model.deleted?)
    end
  end

  describe '#used_by!' do
    context 'not used' do
      before :each do
        expect(model).to_not be_used
      end

      it 'sets used, used_by, and used_at' do
        expect { model.used_by!(user) }.to change { model.used? }.to(true)
        expect(model.used_by).to eq(user.id)
        expect(model.used_at).to be_present
      end
    end

    context 'used' do
      before :each do
        expect { model.used_by!(user) }.to change { model.used? }.to(true)
      end

      it 'does nothing' do
        expect { model.used_by!(FactoryGirl.create :user) }.to_not change { model.used_by }
      end
    end
  end

  describe '#fulfill!' do
    let(:order) { FactoryGirl.build :order, item: model }

    before :each do
      expect(model).to receive(:used?).and_return(used)
    end

    context 'not used' do
      let(:used) { false }

      it 'fulfills the order' do
        expect(model).to receive(:used_by!).with(order.user)
        expect(model.promotion).to receive(:fulfill!).with(order, qty)
        model.fulfill!(order, qty)
      end
    end

    context 'used' do
      let(:used) { true }

      it 'does nothing' do
        expect(model).to_not receive(:used_by!)
        expect(model.promotion).to_not receive(:fulfill!)
        expect(model.fulfill!(order, qty)).to_not be_true
      end
    end
  end

  describe '#reverse!' do
    let(:order) { FactoryGirl.build :order, item: model }

    before :each do
      expect(model).to receive(:used?).and_return(used)
    end

    context 'used' do
      let(:used) { true }

      it 'reverses the order' do
        expect(model.promotion).to receive(:reverse!).with(order)
        model.reverse!(order)
      end
    end

    context 'not used' do
      let(:used) { false }

      it 'does nothing' do
        expect(model.promotion).to_not receive(:reverse!)
        expect(model.reverse!(order)).to_not be_true
      end
    end
  end
end
