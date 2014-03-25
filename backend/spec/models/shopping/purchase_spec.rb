require "spec_helper"
require "spec/models/shared/committable"

describe Purchase do

  it_behaves_like "committable object"

  it { should have_readonly_attribute(:user_id) }

  it { should have_many(:orders) }
  it { should belong_to(:payment_method) }
  it { should belong_to(:billing_address).class_name("Address") }
  it { should belong_to(:shipping_address).class_name("Address") }
  it { should belong_to(:payment) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:user) }

  context "pending" do

    let(:subject) { saved_model }

    it { should be_pending }
    it { should_not validate_presence_of(:payment_method) }
    it { should_not validate_presence_of(:billing_address) }
    it { should_not validate_presence_of(:shipping_address) }
    it { should validate_uniqueness_of(:committed).scoped_to(:user_id) }
  end

  context "committed" do

    let(:model_args) { [ :purchase, :ready ] }
    let :subject do
      saved_model.commit!
      saved_model
    end

    it { should be_committed }
    it { should validate_presence_of(:payment_method) }
    it { should validate_presence_of(:billing_address) }
    it { should validate_presence_of(:shipping_address) }
  end

  describe "#payment_method_currency" do

    let(:model_args) { [ :purchase, :ready ] }

    it "delegates to #payment_method" do

      expect(saved_model.payment_method_currency).to eq(saved_model.payment_method.currency)
      expect(new_model.payment_method_currency).to eq(new_model.payment_method.currency) 
    end
  end

end