shared_examples "item resource" do

  describe "factory model" do

    it("is valid")            { expect(built_item).to be_valid }
    it("is available")        { expect(built_item).to be_available }
    it("is active")           { expect(built_item).to be_active }
    it("is not removed")      { expect(built_item).to_not be_removed }
    it("saves successfully")  { expect(built_item.save).to be_true }
  end

  describe "accessible attributes" do

    it("includes title")       { expect(attributes).to include(:title) }
    it("includes description") { expect(attributes).to include(:description) }
  end

  describe "#title" do

    context "empty" do

      it "is not valid" do

        built_item.title = nil
        expect(built_item).to_not be_valid
        expect(built_item.errors).to have_key(:title)
      end
    end
  end

  describe "#available?" do

    context("removed")  { it("is false") { built_item.removed = true;  expect(built_item).to_not be_available } }
    context("inactive") { it("is false") { built_item.active  = false; expect(built_item).to_not be_available } }
  end

  context "persisted" do

    before(:each) { expect(built_item).to receive(:persisted?).and_return(true) }

    describe "#activate!" do

      it "sets active to true and saves" do

        expect(built_item).to receive(:active=).with(true)
        expect(built_item).to receive(:save)
        built_item.activate!
      end
    end

    describe "#deactivate!" do

      it "sets active to false and saves" do

        expect(built_item).to receive(:active=).with(false)
        expect(built_item).to receive(:save)
        built_item.deactivate!
      end
    end

    describe "#delete!" do

      it "sets removed to true and saves" do

        expect(built_item).to receive(:removed=).with(true)
        expect(built_item).to receive(:save)
        built_item.delete!
      end
    end
  end

  context "non persisted" do

    before(:each) { expect(built_item).to_not be_persisted }

    describe "#activate!" do

      it "sets active to true and saves" do

        expect(built_item).to_not receive(:active=)
        expect(built_item).to_not receive(:save)
        built_item.activate!
      end
    end

    describe "#deactivate!" do

      it "sets active to false and saves" do

        expect(built_item).to_not receive(:active=)
        expect(built_item).to_not receive(:save)
        built_item.deactivate!
      end
    end

    describe "#delete!" do

      it "sets removed to true and saves" do

        expect(built_item).to_not receive(:removed=)
        expect(built_item).to_not receive(:save)
        built_item.delete!
      end
    end
  end
end