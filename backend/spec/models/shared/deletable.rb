shared_examples "deletable model" do

  it { should_not allow_mass_assignment_of(:deleted) }

  context "class" do
    let(:subject) { described_class }
    it { should respond_to(:deleted).with(0).argument }
    it { should respond_to(:kept).with(0).argument }
  end

  context "instance" do
    let(:subject) { described_class.new }
    it { should respond_to(:deleted).with(0).argument }
    it { should respond_to(:deleted=).with(1).argument }
    it { should respond_to(:deleted?).with(0).argument }
    it { should respond_to(:kept?).with(0).argument }
    it { should respond_to(:delete!).with(0).argument }
  end

  describe "#deleted?" do

    context "new model" do

      it("is false") { expect(new_model.deleted?).to be_false }
    end

    context "saved model" do

      it("is false") { expect(saved_model.deleted?).to be_false }
    end
  end

  describe "#delete!" do

    context "new model" do

      it "cannot be executed" do

        expect(new_model.delete!).to_not be_true
      end

      it "cannot change deleted status" do

        expect{ new_model.delete! }.to_not change{ new_model.deleted? }
      end
    end

    context "saved model" do

      it "can be executed" do

        expect(saved_model.delete!).to be_true
      end

      it "changes deleted status to true" do

        expect{ saved_model.delete! }.to change{ saved_model.deleted? }
        expect(saved_model.deleted?).to be_true
      end
    end
  end

  describe "#kept?" do

    context "new model" do

      it "opposites #deleted?" do

        expect(new_model.kept?).to eq(!new_model.deleted?)
      end
    end

    context "saved model" do

      it "opposites #deleted?" do

        expect(saved_model.kept?).to eq(!saved_model.deleted?)
      end
    end
  end

end