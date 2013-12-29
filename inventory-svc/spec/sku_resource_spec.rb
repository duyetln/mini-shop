module SkuResourceSpec
  extend ActiveSupport::Concern

  included do

    before :each do
      @factory_sku = FactoryGirl.build(described_class.to_s.underscore.to_sym)
    end

    context "factory model" do

      it("is valid")       { expect(@factory_sku.valid?).to be_true }
      it("is available")   { expect(@factory_sku.available?).to be_true }
      it("is active")      { expect(@factory_sku.active?).to be_true }
      it("is not removed") { expect(@factory_sku.removed?).to be_false }
    end

    context "accessible attributes" do

      it "includes title and description" do

        [:title, :description].each do |attr|
          attributes = described_class.accessible_attributes.to_a.map(&:to_sym)
          expect(attributes).to include(attr)
        end
      end
    end

    context "#title" do

      context "empty" do

        it "is not valid" do

          @factory_sku.title = nil
          expect(@factory_sku.valid?).to be_false
          expect(@factory_sku.errors).to have_key(:title)
        end
      end
    end

    context "#available?" do

      context("removed")  { it("is false") { @factory_sku.removed = true;  expect(@factory_sku.available?).to be_false } }
      context("inactive") { it("is false") { @factory_sku.active  = false; expect(@factory_sku.available?).to be_false } }
    end

    context "#activate!" do

      it "sets active to true and saves" do

        expect(@factory_sku).to receive(:active=).with(true)
        expect(@factory_sku).to receive(:save)
        @factory_sku.activate!
      end
    end

    context "#deactivate!" do

      it "sets active to false and saves" do

        expect(@factory_sku).to receive(:active=).with(false)
        expect(@factory_sku).to receive(:save)
        @factory_sku.deactivate!
      end
    end

    context "#delete!" do

      it "sets removed to true and saves" do

        expect(@factory_sku).to receive(:removed=).with(true)
        expect(@factory_sku).to receive(:save)
        @factory_sku.delete!
      end
    end

  end

end