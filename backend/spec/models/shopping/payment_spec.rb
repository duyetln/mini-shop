require "spec_helper"
require "spec/models/shared/committable"

describe Payment do

  it_behaves_like "committable object"

  it { should belong_to(:payment_method) }
  it { should belong_to(:billing_address).class_name("Address") }
  it { should belong_to(:user) }
  it { should belong_to(:currency) }

  it { should validate_numericality_of(:amount).is_greater_than(0) }

  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:payment_method) }
  it { should validate_presence_of(:billing_address) }
  it { should validate_presence_of(:currency) }
  it { should validate_presence_of(:amount) }

  let(:payment) { FactoryGirl.create(:payment) }

  describe "#payment_method_currency" do

    it "delegates to #payment_method" do

      expect(payment.payment_method_currency).to eq(payment.payment_method.currency)
    end
  end

  describe "#uuid" do

    context "new payment" do

      it "is present" do

        expect(FactoryGirl.create(:payment).uuid).to be_present
      end
    end

    context "saved payment" do

      it "is present" do

        expect(FactoryGirl.build(:payment).uuid).to be_present
      end
    end
  end

  describe "#refunded?" do

    context "new payment" do

      it "is false" do

        expect(FactoryGirl.create(:payment)).to_not be_refunded
      end
    end

    context "saved payment" do

      it "is false" do

        expect(FactoryGirl.build(:payment)).to_not be_refunded
      end
    end
  end

  describe "#commit!" do

    it "subtracts payment amount from payment method" do

      payment_method = payment.payment_method
      amount = Currency.exchange(payment.amount, payment.currency, payment_method.currency)
      expect{ payment.commit! }.to change{ payment.payment_method.balance }.by(-amount)
    end
  end
  
end