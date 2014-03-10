shared_examples "activable object" do

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

    context "new object" do

      it("is true") { expect(new_object.active?).to be_true }
    end

    context "created object" do

      it("is true") { expect(created_object.active?).to be_true }
    end
  end

  describe "#activate!" do

    context "new object" do

      it "cannot be executed" do

        expect(new_object.activate!).to_not be_true
      end

      it "cannot change active status" do

        expect{ new_object.activate! }.to_not change{ new_object.active? }
      end
    end

    context "created object" do

      it "can be executed" do

        created_object.deactivate!
        expect(created_object.activate!).to be_true
      end

      it "changes active status to true" do

        created_object.deactivate!
        expect{ created_object.activate! }.to change{ created_object.active? }
        expect(created_object.active?).to be_true
      end
    end
  end

  describe "#deactivate!" do

    context "new object" do

      it "cannot be executed" do

        expect(new_object.deactivate!).to_not be_true
      end

      it "cannot change active status" do

        expect{ new_object.deactivate! }.to_not change{ new_object.active? }
      end
    end

    context "created object" do

      it "can be executed" do

        expect(created_object.deactivate!).to be_true
      end

      it "changes active status to false" do

        expect{ created_object.deactivate! }.to change{ created_object.active? }
        expect(created_object.active?).to be_false
      end
    end
  end

  describe "#inactive?" do

    context "new object" do
      
      it "opposites #active?" do

        expect(new_object.inactive?).to eq(!new_object.active?)
      end
    end

    context "created object" do

      it "opposites #active?" do
        
        expect(created_object.inactive?).to eq(!created_object.active?)
      end
    end
  end

end