shared_examples 'default #committable?' do
  describe '#committable?' do
    it 'equals #pending?' do
      expect(model.committable?).to eq(model.pending?)
    end
  end
end

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
    it { should respond_to(:committed_at=).with(1).argument }
    it { should respond_to(:committed?).with(0).argument }
    it { should respond_to(:pending?).with(0).argument }
    it { should respond_to(:commit!).with(0).argument }
  end

  context 'new record' do
    let(:model) { described_class.new }

    it 'defaults to pending' do
      expect(model).to be_pending
      expect(model.committed_at).to be_nil
    end
  end

  describe '#committed?' do
    it 'equals #committed' do
      expect(model.committed?).to eq(model.committed)
    end
  end

  describe '#pending?' do
    it 'opposites #committed?' do
      expect(model.pending?).to eq(!model.committed?)
    end
  end

  describe '#commit!' do
    before :each do
      expect(model).to receive(:committable?).and_return(committable)
    end

    context 'not committable' do
      let(:committable) { false }

      it 'returns status' do
        expect(model.commit!).to eq(model.committed?)
      end

      it 'cannot change committed status' do
        expect { model.commit! }.to_not change { model.committed? }
      end

      it 'cannot change committed_at' do
        expect { model.commit! }.to_not change { model.committed_at }
      end
    end

    context 'committable' do
      let(:committable) { true }

      it 'returns status' do
        expect(model.commit!).to eq(model.committed?)
      end

      it 'changes committed status to true' do
        expect { model.commit! }.to change { model.committed? }.to(committable)
      end

      it 'sets committed_at' do
        expect { model.commit! }.to change { model.committed_at }
        expect(model.committed_at).to be_present
      end
    end
  end
end
