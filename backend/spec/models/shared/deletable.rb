shared_examples "deletable object" do

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

    context "new object" do

      it("is false") { expect(new_object.deleted?).to be_false }
    end

    context "created object" do

      it("is false") { expect(created_object.deleted?).to be_false }
    end
  end

  describe "#delete!" do

    context "new object" do

      it "cannot be executed" do

        expect(new_object.delete!).to_not be_true
      end

      it "cannot change deleted status" do

        expect{ new_object.delete! }.to_not change{ new_object.deleted? }
      end
    end

    context "created object" do

      it "can be executed" do

        expect(created_object.delete!).to be_true
      end

      it "changes deleted status to true" do

        expect{ created_object.delete! }.to change{ created_object.deleted? }
        expect(created_object.deleted?).to be_true
      end
    end
  end

  describe "#kept?" do

    context "new object" do

      it "opposites #deleted?" do

        expect(new_object.kept?).to eq(!new_object.deleted?)
      end
    end

    context "created object" do

      it "opposites #deleted?" do

        expect(created_object.kept?).to eq(!created_object.deleted?)
      end
    end
  end

end