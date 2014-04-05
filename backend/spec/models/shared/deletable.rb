shared_examples 'deletable model' do

  it { should_not allow_mass_assignment_of(:deleted) }

  context 'class' do
    let(:subject) { described_class }
    it { should respond_to(:deleted).with(0).argument }
    it { should respond_to(:kept).with(0).argument }
  end

  context 'instance' do
    let(:subject) { described_class.new }
    it { should respond_to(:deleted).with(0).argument }
    it { should respond_to(:deleted=).with(1).argument }
    it { should respond_to(:deleted?).with(0).argument }
    it { should respond_to(:kept?).with(0).argument }
    it { should respond_to(:delete!).with(0).argument }
  end

  context 'new record' do
    let(:model) { described_class.new }

    it 'defaults to pending' do
      expect(model).to be_kept
    end
  end

  describe '#deleted?' do
    it 'equals #deleted' do
      expect(model.deleted?).to eq(model.deleted)
    end
  end

  describe '#delete!' do
    before :each do
      model.deleted = deleted
    end

    context 'deleted' do
      let(:deleted) { true }

      it 'cannot be executed' do
        expect(model.delete!).to_not be_true
      end

      it 'cannot change deleted status' do
        expect { model.delete! }.to_not change { model.deleted? }
      end
    end

    context 'kept' do
      let(:deleted) { false }

      it 'can be executed' do
        expect(model.delete!).to be_true
      end

      it 'changes deleted status to true' do
        expect { model.delete! }.to change { model.deleted? }.to(!deleted)
      end
    end
  end

  describe '#kept?' do
    it 'opposites #deleted?' do
      expect(model.kept?).to eq(!model.deleted?)
    end
  end

end
