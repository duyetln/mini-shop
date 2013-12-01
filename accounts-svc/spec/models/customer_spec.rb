require "spec_helper"

describe Customer do

  describe "#save" do

    before(:each) { @customer = FactoryGirl.build :customer }
    after(:each)  { @customer.destroy }

    context("blank first_name") { it("should not save") { @customer.first_name  = nil; expect(@customer.save).to be_false } }
    context("blank last_name")  { it("should not save") { @customer.last_name   = nil; expect(@customer.save).to be_false } }
    context("blank birthdate")  { it("should not save") { @customer.birthdate   = nil; expect(@customer.save).to be_false } }
    context("blank email")      { it("should not save") { @customer.email       = nil; expect(@customer.save).to be_false } }
    context("blank password")   { it("should not save") { @customer.password    = nil; expect(@customer.save).to be_false } }
    
    context "valid input" do

      before(:each) { @password = @customer.password; expect(@customer.save).to eq(true) }

      it("should set uuid")               { expect(@customer.uuid).to                           be_present    } 
      it("should set confirmation_code")  { expect(@customer.confirmation_code).to              be_present    }
      it("should set password")           { expect(@customer.password).to                       be_present    }
      it("should encrypt password")       { expect(BCrypt::Password.new(@customer.password)).to eq(@password) }
    end

    context "password changed" do

      it "should encrypt password and save" do
        new_password = random_string

        @customer.save
        @customer.password = new_password
        @customer.save
        expect(BCrypt::Password.new(@customer.password)).to eq(new_password)
      end
    end
  end

  describe "#confirmed?" do

    context("new user") { it("should return false") { expect(FactoryGirl.build(:customer).confirmed?).to be_false } }
    context "persisted user" do

      before(:each) { @customer = FactoryGirl.create :customer }
      context("confirmation code blank")   { it("should return true")  { @customer.confirmation_code = nil; @customer.save; expect(@customer.confirmed?).to be_true  } }
      context("confirmation code present") { it("should return false") {                                                    expect(@customer.confirmed?).to be_false } }
    end
  end

  describe "#confirm!" do

    context("new user") { it("should return false") { expect(FactoryGirl.build(:customer).confirm!).to be_false } }
    context "persisted user" do

      before(:each) { @customer = FactoryGirl.create :customer }
      context("confirmation code blank")   { it("should return false") { @customer.confirmation_code = nil; @customer.save; expect(@customer.confirm!).to be_false } }
      context "confirmation code present" do 

        it("should return true")  do 
          expect(@customer.confirm!).to be_true
          expect(@customer.confirmation_code).to be_blank
        end
      end
    end
  end

  describe ".authenticate" do

    before(:each) do
      @customer = FactoryGirl.build :customer
      @password = @customer.password
      @customer.save
    end

    context("non-matching uuid")     { it("should return nil") { expect(Customer.authenticate(@customer.uuid + random_string, random_string)).to be_nil } }
    context("unconfirmed user")      { it("should return nil") { expect(Customer.authenticate(@customer.uuid, @customer.password)).to be_nil } }
    context("non-matching password") { it("should return nil") { expect(Customer.authenticate(@customer.uuid, @customer.password + random_string)).to be_nil } }
    context "matching uuid, matching password, confirmed user" do

      it "should return the customer" do
        @customer.confirm!
        expect(Customer.authenticate(@customer.uuid, @password)).to eq(@customer)
      end
    end
  end
end