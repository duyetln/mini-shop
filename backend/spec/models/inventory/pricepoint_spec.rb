require "spec_helper"

describe Pricepoint do

  it { should validate_uniqueness_of(:name) }
  it { should validate_presence_of(:name) }

  describe "#amount" do

    let(:pricepoint) { FactoryGirl.create :pricepoint }

    context "currency found" do

      it "returns correct amount" do

        currency = pricepoint.currencies.sample
        pricepoint_price = pricepoint.pricepoint_prices.where(currency_id: currency.id).first
        expect(pricepoint.amount(currency)).to eq(pricepoint_price.amount)
      end
    end

    context "currency not found" do

      it "returns nil" do

        expect(pricepoint.amount(Currency.new)).to eq(nil)
      end
    end
  end

end