shared_examples 'committable model' do

  it { should_not allow_mass_assignment_of(:committed) }
  it { should_not allow_mass_assignment_of(:committed_at) }

  context 'class' do
    let(:subject) { described_class }
    it { should respond_to(:committed).with(0).argument }
    it { should respond_to(:pending).with(0).argument }
  end

  context 'instance' do
    let(:subject) { described_class.new }
    it { should respond_to(:committed).with(0).argument }
    it { should respond_to(:committed=).with(1).argument }
    it { should respond_to(:committed_at).with(0).argument }
    it { should respond_to(:committed_at=).with(0).argument }
    it { should respond_to(:committed?).with(0).argument }
    it { should respond_to(:pending?).with(0).argument }
    it { should respond_to(:commit!).with(0).argument }
  end

  describe '#committed?' do
    it 'equals #committed' do
      expect(saved_model.committed?).to eq(saved_model.committed)
    end
  end

  describe '#pending?' do
    it 'opposites #committed?' do
      expect(saved_model.pending?).to eq(!saved_model.committed?)
    end
  end

  describe '#commit!' do
    before :each do
      saved_model.committed = committed
    end

    context 'committed' do
      let(:committed) { true }

      it 'cannot be executed' do
        expect(saved_model.commit!).to_not be_true
      end

      it 'cannot change committed status' do
        expect { saved_model.commit! }.to_not change { saved_model.committed? }
      end

      it 'cannot change committed_at' do
        expect { saved_model.commit! }.to_not change { saved_model.committed_at }
      end
    end

    context 'pending' do
      let(:committed) { false }

      it 'can be executed' do
        expect(saved_model.commit!).to be_true
      end

      it 'changes committed status to true' do
        expect { saved_model.commit! }.to change { saved_model.committed? }.to(!committed)
      end

      it 'sets committed_at' do
        expect { saved_model.commit! }.to change { saved_model.committed_at }
        expect(saved_model.committed_at).to be_present
      end
    end
  end

end
