require "spec_helper"

describe Pricepoint do

  it { should have_many(:pricepoint_prices) }
  it { should have_many(:currencies).through(:pricepoint_prices) }

  it { should validate_uniqueness_of(:name) }
  it { should validate_presence_of(:name) }

  describe "#amount" do

    context "currency found" do

      it "returns correct amount" do

        currency = saved_model.currencies.sample
        pricepoint_price = saved_model.pricepoint_prices.where(currency_id: currency.id).first
        expect(saved_model.amount(currency)).to eq(pricepoint_price.amount)
      end
    end

    context "currency not found" do

      it "returns nil" do

        expect(saved_model.amount(Currency.new)).to eq(nil)
      end
    end
  end

end