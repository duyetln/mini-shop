shared_examples "sku resource" do

  context "factory model" do

    it("is valid")       { expect(built_sku.valid?).to be_true }
    it("is available")   { expect(built_sku.available?).to be_true }
    it("is active")      { expect(built_sku.active?).to be_true }
    it("is not removed") { expect(built_sku.removed?).to be_false }
  end

  context "accessible attributes" do

    it("includes title")       { expect(attributes).to include(:title) }
    it("includes description") { expect(attributes).to include(:description) }
  end

  context "#title" do

    context "empty" do

      it "is not valid" do

        built_sku.title = nil
        expect(built_sku.valid?).to be_false
        expect(built_sku.errors).to have_key(:title)
      end
    end
  end

  context "#available?" do

    context("removed")  { it("is false") { built_sku.removed = true;  expect(built_sku.available?).to be_false } }
    context("inactive") { it("is false") { built_sku.active  = false; expect(built_sku.available?).to be_false } }
  end

  context "#activate!" do

    it "sets active to true and saves" do

      expect(built_sku).to receive(:active=).with(true)
      expect(built_sku).to receive(:save)
      built_sku.activate!
    end
  end

  context "#deactivate!" do

    it "sets active to false and saves" do

      expect(built_sku).to receive(:active=).with(false)
      expect(built_sku).to receive(:save)
      built_sku.deactivate!
    end
  end

  context "#delete!" do

    it "sets removed to true and saves" do

      expect(built_sku).to receive(:removed=).with(true)
      expect(built_sku).to receive(:save)
      built_sku.delete!
    end
  end

end