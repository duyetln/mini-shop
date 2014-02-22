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

  shared_examples "item not allowed to modify active flag" do

    it "does not modify active flag" do

      expect(test_item).to_not receive(:active=)
      expect(test_item).to_not receive(:save)
      test_item.send(action)
    end
  end

  shared_examples "item not allowed to modify removed flag" do

    it "does not modify removed flag" do

      expect(test_item).to_not receive(:removed=)
      expect(test_item).to_not receive(:save)
      test_item.send(action)
    end
  end

  context "persisted" do

    before(:each) { expect(built_item).to receive(:persisted?).and_return(true) }

    let(:test_item) { built_item }

    context "inactive" do

      before(:each) { expect(built_item).to receive(:active?).and_return(false) }

      describe "#activate!" do

        it "sets active to true and saves" do

          expect(built_item).to receive(:active=).with(true)
          expect(built_item).to receive(:save)
          built_item.activate!
        end
      end

      describe "#deactivate!" do

        let(:action) { :deactivate! }

        it_behaves_like "item not allowed to modify active flag"
      end
    end

    context "active" do

      before(:each) { expect(built_item).to receive(:active?).and_return(true) }

      describe "#activate!" do

        let(:action) { :activate! }

        it_behaves_like "item not allowed to modify active flag"
      end

      describe "#deactivate!" do

        it "sets active to false and saves" do

          expect(built_item).to receive(:active=).with(false)
          expect(built_item).to receive(:save)
          built_item.deactivate!
        end
      end
    end

    context "kept" do

      before(:each) { expect(built_item).to receive(:removed?).and_return(false) }

      describe "#delete!" do

        it "sets removed to true and saves" do

          expect(built_item).to receive(:removed=).with(true)
          expect(built_item).to receive(:save)
          built_item.delete!
        end
      end
    end

    context "removed" do

      before(:each) { expect(built_item).to receive(:removed?).and_return(true) }

      describe "#delete!" do

        let(:action) { :delete! }

        it_behaves_like "item not allowed to modify removed flag"
      end
    end
  end

  context "non persisted" do

    before(:each) { expect(built_item).to_not be_persisted }

    let(:test_item) { built_item }

    describe "#activate!" do

      let(:action) { :activate! }

      it_behaves_like "item not allowed to modify active flag"
    end

    describe "#deactivate!" do

      let (:action) { :deactivate! }

      it_behaves_like "item not allowed to modify active flag"
    end

    describe "#delete!" do

      let(:action) { :delete! }

      it_behaves_like "item not allowed to modify removed flag"
    end
  end
end