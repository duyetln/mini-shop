require 'models/spec_setup'

describe Status do
  let(:subject) { described_class.new }

  it { should belong_to(:source) }

  it { should validate_presence_of(:source) }
  it { should validate_presence_of(:status) }

  describe Status::Mixin do
    before :all do
      class TestItem < DigitalItem
        STATUS = { brand_new: 0, used: 1 }
        include Status::Mixin
      end
    end

    let(:test_instance) do
      item = TestItem.new
      item.save!(validate: false)
      item
    end

    let(:subject) { test_instance }

    it { should respond_to(:brand_new?) }
    it { should respond_to(:used?) }
    it { should respond_to(:mark_brand_new!) }
    it { should respond_to(:mark_used!) }
    it { should respond_to(:status) }
    it { should respond_to(:marked?) }

    it { should have_many(:statuses) }

    describe '#marked?' do
      it 'checks the presence of any status' do
        expect(test_instance.marked?).to eq(test_instance.status.present?)
      end
    end

    describe '#unmarked?' do
      it 'opposites #marked?' do
        expect(test_instance.unmarked?).to eq(!test_instance.marked?)
      end
    end

    describe '#status' do
      it 'is the last status' do
        expect(test_instance.status).to eq(test_instance.statuses.order(:created_at).last)
      end
    end

    describe '#brand_new?' do
      it 'checks the status correctly' do
        expect(test_instance.brand_new?).to eq(
          test_instance.status &&
          test_instance.status.status == TestItem::STATUS[:brand_new]
        )
      end
    end

    describe '#used?' do
      it 'checks the status correctly' do
        expect(test_instance.brand_new?).to eq(
          test_instance.status &&
          test_instance.status.status == TestItem::STATUS[:used]
        )
      end
    end

    describe '#mark_brand_new!' do
      it 'marks the status correctly' do
        expect { test_instance.mark_brand_new! }.to change { test_instance.statuses.count }.by(1)
        expect(test_instance).to be_brand_new
      end
    end

    describe '#mark_used!' do
      it 'marks the status correctly' do
        expect { test_instance.mark_used! }.to change { test_instance.statuses.count }.by(1)
        expect(test_instance).to be_used
      end
    end
  end
end
