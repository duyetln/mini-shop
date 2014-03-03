require "spec_helper"

describe Discount do

  it { should validate_presence_of(:rate) }
  it { should validate_presence_of(:name) }

  it { should validate_numericality_of(:rate).is_greater_than_or_equal_to(0) }
  it { should validate_uniqueness_of(:name) }

  describe "discount dates" do

    let(:discount) { FactoryGirl.build :discount, :half }

    context "start date is after end date" do

      it "is valid" do

        discount.start_at = 5.days.from_now
        discount.end_at   = 5.days.ago
        expect(discount).to_not be_valid
      end
    end

    context "start date is befor end date" do

      it "is valid" do

        discount.start_at = 5.days.ago
        discount.end_at   = 5.days.from_now
        expect(discount).to be_valid
      end
    end
  end

  describe "#rate_at" do

    let(:discount) { FactoryGirl.build :discount, :random, time }

    context "past" do

      let(:time) { :past }

      it "returns 0 rate" do

        expect(discount.rate_at).to eq(0)
      end
    end

    context "present" do

      let(:time) { :present }

      it "returns saved rate" do

        expect(discount.rate_at).to eq(discount.rate)
      end
    end

    context "future" do

      let(:time) { :future }

      it "returns 0 rate" do

        expect(discount.rate_at).to eq(0)
      end
    end
  end

  describe "#discounted?" do

    let(:discount) { FactoryGirl.build :discount, :random } 

    context "#rate_at is non-zero" do

      it "is false" do

        expect(discount).to receive(:rate_at).and_return(rand(10)+1)
        expect(discount.discounted?).to be_true
      end
    end

    context "#rate_at is zero" do

      it "is true" do

        expect(discount).to receive(:rate_at).and_return(0)
        expect(discount.discounted?).to be_false
      end
    end
  end

  describe "#current_rate" do

    let(:discount) { FactoryGirl.build :discount, :random } 

    it "delegates to #rate_at" do

      expect(discount.current_rate).to eq(discount.rate_at)
    end
  end
end