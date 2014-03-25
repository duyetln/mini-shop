shared_examples "committable model" do

  it { should_not allow_mass_assignment_of(:committed) }
  it { should_not allow_mass_assignment_of(:committed_at) }

  context "class" do
    let(:subject) { described_class }
    it { should respond_to(:committed).with(0).argument }
    it { should respond_to(:pending).with(0).argument }
  end

  context "instance" do
    let(:subject) { described_class.new }
    it { should respond_to(:committed).with(0).argument }
    it { should respond_to(:committed=).with(1).argument }
    it { should respond_to(:committed_at).with(0).argument }
    it { should respond_to(:committed_at=).with(0).argument }
    it { should respond_to(:committed?).with(0).argument }
    it { should respond_to(:pending?).with(0).argument }
    it { should respond_to(:commit!).with(0).argument }
  end

  describe "#committed?" do

    context "new model" do

      it("is false") { expect(new_model).to_not be_committed }
    end

    context "saved model" do

      it("is false") { expect(saved_model).to_not be_committed }
    end
  end

  describe "#pending?" do

    context "new model" do

      it "opposites #committed?" do

        expect(new_model.pending?).to eq(!new_model.committed?)
      end
    end

    context "saved model" do

      it "opposites #committed?" do

        expect(saved_model.pending?).to eq(!saved_model.committed?)
      end
    end
  end

  describe "#commit!" do

    context "new model" do

      it "cannot be executed" do

        expect(new_model.commit!).to_not be_true
      end

      it "cannot change committed status" do

        expect{ new_model.commit! }.to_not change{ new_model.committed? }
      end

      it "cannot change committed_at" do

        expect{ new_model.commit! }.to_not change{ new_model.committed_at }
      end
    end

    context "saved model" do

      it "can be executed" do

        expect(saved_model.commit!).to be_true
      end

      it "changes committed status to true" do

        expect{ saved_model.commit! }.to change{ saved_model.committed? }
        expect(saved_model.committed?).to be_true
      end

      it "sets committed_at" do

        expect{ saved_model.commit! }.to change{ saved_model.committed_at }
        expect(saved_model.committed_at).to be_present
      end
    end
  end

end