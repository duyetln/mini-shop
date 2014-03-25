shared_examples "activable model" do

  it { should_not allow_mass_assignment_of(:active) }

  context "class" do
    let(:subject) { described_class }
    it { should respond_to(:active).with(0).argument }
    it { should respond_to(:inactive).with(0).argument }
  end

  context "instance" do
    let(:subject) { described_class.new }
    it { should respond_to(:active).with(0).argument }
    it { should respond_to(:active=).with(1).argument }
    it { should respond_to(:active?).with(0).argument }
    it { should respond_to(:inactive?).with(0).argument }
    it { should respond_to(:activate!).with(0).argument }
    it { should respond_to(:deactivate!).with(0).argument }
  end

  describe "#active?" do

    context "new model" do

      it("is true") { expect(new_model.active?).to be_true }
    end

    context "saved model" do

      it("is true") { expect(saved_model.active?).to be_true }
    end
  end

  describe "#activate!" do

    context "new model" do

      it "cannot be executed" do

        expect(new_model.activate!).to_not be_true
      end

      it "cannot change active status" do

        expect{ new_model.activate! }.to_not change{ new_model.active? }
      end
    end

    context "saved model" do

      it "can be executed" do

        saved_model.deactivate!
        expect(saved_model.activate!).to be_true
      end

      it "changes active status to true" do

        saved_model.deactivate!
        expect{ saved_model.activate! }.to change{ saved_model.active? }
        expect(saved_model.active?).to be_true
      end
    end
  end

  describe "#deactivate!" do

    context "new model" do

      it "cannot be executed" do

        expect(new_model.deactivate!).to_not be_true
      end

      it "cannot change active status" do

        expect{ new_model.deactivate! }.to_not change{ new_model.active? }
      end
    end

    context "saved model" do

      it "can be executed" do

        expect(saved_model.deactivate!).to be_true
      end

      it "changes active status to false" do

        expect{ saved_model.deactivate! }.to change{ saved_model.active? }
        expect(saved_model.active?).to be_false
      end
    end
  end

  describe "#inactive?" do

    context "new model" do
      
      it "opposites #active?" do

        expect(new_model.inactive?).to eq(!new_model.active?)
      end
    end

    context "saved model" do

      it "opposites #active?" do
        
        expect(saved_model.inactive?).to eq(!saved_model.active?)
      end
    end
  end

end