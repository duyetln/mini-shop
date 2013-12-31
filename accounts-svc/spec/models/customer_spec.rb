require "spec_helper"

describe Customer do 

  context "factory model" do

    it("is valid")           { expect(built_customer.valid?).to be_true }
    it("saves successfully") { expect(built_customer.save).to be_true }
  end

  describe "#save" do

    context("blank first_name") { it("does not save") { built_customer.first_name  = nil; expect(built_customer.save).to be_false } }
    context("blank last_name")  { it("does not save") { built_customer.last_name   = nil; expect(built_customer.save).to be_false } }
    context("blank birthdate")  { it("does not save") { built_customer.birthdate   = nil; expect(built_customer.save).to be_false } }
    context("blank email")      { it("does not save") { built_customer.email       = nil; expect(built_customer.save).to be_false } }
    context("blank password")   { it("does not save") { built_customer.password    = nil; expect(built_customer.save).to be_false } }
    
    context "valid input" do

      before(:each) { @password = built_customer.password; expect(built_customer.save).to eq(true) }

      it("sets uuid")              { expect(built_customer.uuid).to be_present } 
      it("sets confirmation_code") { expect(built_customer.confirmation_code).to be_present }
      it("sets password")          { expect(built_customer.password).to be_present }
      it("encrypts password")      { expect(BCrypt::Password.new(built_customer.password)).to eq(@password) }
    end

    context "password changed" do

      it "encrypts password and saves" do

        created_customer.password = random_string
        created_customer.save
        expect(BCrypt::Password.new(created_customer.password)).to eq(random_string)
      end
    end
  end

  describe "#confirmed?" do

    context("new user") { it("returns false") { expect(built_customer.confirmed?).to be_false } }

    context "persisted user" do

      context "confirmation code blank" do
        
        it "returns true" do

          created_customer.confirmation_code = nil
          created_customer.save; expect(created_customer.confirmed?).to be_true
        end
      end

      context("confirmation code present") { it("returns false") { expect(created_customer.confirmed?).to be_false } }
    end
  end

  describe "#confirm!" do

    context("new user") { it("returns false") { expect(built_customer.confirm!).to be_false } }
    
    context "persisted user" do

      context "confirmation code blank" do

        it "returns false" do

          created_customer.confirmation_code = nil
          created_customer.save
          expect(created_customer.confirm!).to be_false
        end
      end

      context "confirmation code present" do 

        it("should return true")  do

          expect(created_customer.confirm!).to be_true
          expect(created_customer.confirmation_code).to be_blank
        end
      end
    end
  end

  describe ".authenticate" do

    before :each do
      @password = built_customer.password
      built_customer.save
    end

    context("non-matching uuid")     { it("returns nil") { expect(Customer.authenticate(built_customer.uuid + random_string, random_string)).to be_nil } }
    context("unconfirmed user")      { it("returns nil") { expect(Customer.authenticate(built_customer.uuid, built_customer.password)).to be_nil } }
    context("non-matching password") { it("returns nil") { expect(Customer.authenticate(built_customer.uuid, built_customer.password + random_string)).to be_nil } }
    context "matching uuid, matching password, confirmed user" do

      it "returns the customer" do
        
        built_customer.confirm!
        expect(Customer.authenticate(built_customer.uuid, @password)).to eq(built_customer)
      end
    end
  end
end