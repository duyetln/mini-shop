require "spec_helper"

describe Price do

  it { should belong_to(:pricepoint) }
  it { should belong_to(:discount) }

  it { should validate_presence_of(:pricepoint) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

  describe "#discounted?" do

    context "discount present" do

      let(:price) { FactoryGirl.create :price, :discounted }

      it "delegates to Discount#discounted?" do

        expect(price.discounted?).to eq(price.discount.discounted?)
      end
    end

    context "discount not present" do

      let(:price) { FactoryGirl.create :price }

      it "is not discounted" do

        expect(price.discounted?).to be_false
      end
    end
  end

  describe "#amount" do

    let(:currency) { price.pricepoint.currencies.sample }

    context "discount present" do

      let(:price) { FactoryGirl.create :price, :discounted }

      it "returns correct amount" do

        expect(price.amount(currency)).to eq(price.pricepoint.amount(currency) * ( 1 - price.discount.current_rate) )
      end
    end

    context "discount not present" do

      let(:price) { FactoryGirl.create :price }

      it "returns correct amount" do

        expect(price.amount(currency)).to eq(price.pricepoint.amount(currency))
      end
    end
  end

end