require "spec/models/shared/activable"
require "spec/models/shared/deletable"
require "spec/models/shared/displayable"

shared_examples "item resource" do

  it { should allow_mass_assignment_of(:title) }
  it { should allow_mass_assignment_of(:description) }

  it { should validate_presence_of(:title) }

  it_behaves_like "activable object"
  it_behaves_like "deletable object"
  it_behaves_like "displayable object"

  describe "factory model" do

    it("is valid") { expect(new_item).to be_valid }
    it("saves successfully") { expect(created_item).to be_present}
  end

  context "new item" do

    it("is inactive") { expect(new_item.active?).to be_true }
    it("is not deleted") { expect(new_item.deleted?).to be_false }

    describe "#activate!" do

      it "cannot be executed" do

        expect(new_item.activate!).to_not be_true
      end

      it "cannot change active status" do

        expect{ new_item.activate! }.to_not change{ new_item.active }
      end
    end

    describe "#deactivate!" do

      it "cannot be executed" do

        expect(new_item.deactivate!).to_not be_true
      end

      it "cannot change active status" do

        expect{ new_item.deactivate! }.to_not change{ new_item.active }
      end
    end

    describe "#delete!" do

      it "cannot be executed" do

        expect(new_item.delete!).to_not be_true
      end

      it "cannot change deleted status" do

        expect{ new_item.delete! }.to_not change{ new_item.deleted }
      end
    end
  end

  context "created item" do

    it("is active") { expect(created_item.active?).to be_true }
    it("is not deleted") { expect(created_item.deleted?).to be_false }

    describe "#deactivate!" do

      it "can be executed" do

        expect(created_item.deactivate!).to be_true
      end

      it "changes active status to false" do

        expect{ created_item.deactivate! }.to change{ created_item.active }
        expect(created_item.active?).to be_false
      end
    end

    describe "#activate!" do

      it "can be executed" do

        created_item.deactivate!
        expect(created_item.activate!).to be_true
      end

      it "changes active status to true" do

        created_item.deactivate!
        expect{ created_item.activate! }.to change{ created_item.active }
        expect(created_item.active?).to be_true
      end
    end

    describe "#delete!" do

      it "can be executed" do

        expect(created_item.delete!).to be_true
      end

      it "changes deleted status to true" do

        expect{ created_item.delete! }.to change{ created_item.deleted }
        expect(created_item.deleted?).to be_true
      end
    end
  end

  describe "#available?" do

    context("deleted")  { it("is false") { created_item.delete!;     expect(created_item).to_not be_available } }
    context("inactive") { it("is false") { created_item.deactivate!; expect(created_item).to_not be_available } }
  end

end