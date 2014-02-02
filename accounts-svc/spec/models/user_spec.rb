require "spec_helper"

describe User do 

  context "factory model" do

    it("is valid")           { expect(built_user.valid?).to be_true }
    it("saves successfully") { expect(built_user.save).to be_true }
  end

  describe "#save" do

    context("blank first_name") { it("does not save") { built_user.first_name  = nil; expect(built_user.save).to be_false } }
    context("blank last_name")  { it("does not save") { built_user.last_name   = nil; expect(built_user.save).to be_false } }
    context("blank birthdate")  { it("does not save") { built_user.birthdate   = nil; expect(built_user.save).to be_false } }
    context("blank email")      { it("does not save") { built_user.email       = nil; expect(built_user.save).to be_false } }
    context("blank password")   { it("does not save") { built_user.password    = nil; expect(built_user.save).to be_false } }
    
    context "valid input" do

      before(:each) { @password = built_user.password; expect(built_user.save).to eq(true) }

      it("sets uuid")              { expect(built_user.uuid).to be_present } 
      it("sets confirmation_code") { expect(built_user.confirmation_code).to be_present }
      it("sets password")          { expect(built_user.password).to be_present }
      it("encrypts password")      { expect(BCrypt::Password.new(built_user.password)).to eq(@password) }
    end

    context "password changed" do

      it "encrypts password and saves" do

        created_user.password = random_string
        created_user.save
        expect(BCrypt::Password.new(created_user.password)).to eq(random_string)
      end
    end
  end

  describe "#confirmed?" do

    context("new user") { it("returns false") { expect(built_user.confirmed?).to be_false } }

    context "persisted user" do

      context "confirmation code blank" do
        
        it "returns true" do

          created_user.confirmation_code = nil
          created_user.save; expect(created_user.confirmed?).to be_true
        end
      end

      context("confirmation code present") { it("returns false") { expect(created_user.confirmed?).to be_false } }
    end
  end

  describe "#confirm!" do

    context("new user") { it("returns false") { expect(built_user.confirm!).to be_false } }
    
    context "persisted user" do

      context "confirmation code blank" do

        it "returns false" do

          created_user.confirmation_code = nil
          created_user.save
          expect(created_user.confirm!).to be_false
        end
      end

      context "confirmation code present" do 

        it("should return true")  do

          expect(created_user.confirm!).to be_true
          expect(created_user.confirmation_code).to be_blank
        end
      end
    end
  end

  describe ".authenticate" do

    before :each do
      @password = built_user.password
      built_user.save
    end

    context("non-matching uuid")     { it("returns nil") { expect(User.authenticate(built_user.uuid + random_string, random_string)).to be_nil } }
    context("unconfirmed user")      { it("returns nil") { expect(User.authenticate(built_user.uuid, built_user.password)).to be_nil } }
    context("non-matching password") { it("returns nil") { expect(User.authenticate(built_user.uuid, built_user.password + random_string)).to be_nil } }
    context "matching uuid, matching password, confirmed user" do

      it "returns the user" do
        
        built_user.confirm!
        expect(User.authenticate(built_user.uuid, @password)).to eq(built_user)
      end
    end
  end
end