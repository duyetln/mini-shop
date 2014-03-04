require "spec_helper"

describe User do

  it { should allow_mass_assignment_of(:first_name) }
  it { should allow_mass_assignment_of(:last_name) }
  it { should allow_mass_assignment_of(:email) }
  it { should allow_mass_assignment_of(:birthdate) }
  it { should allow_mass_assignment_of(:password) }

  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:birthdate) }
  it { should validate_presence_of(:password) }

  it { should validate_uniqueness_of(:email) }
  it { should ensure_length_of(:password).is_at_least(5) }
  it { should have_readonly_attribute(:uuid) }

  describe "factory model" do

    it("is valid") { expect(built_user.valid?).to be_true }
    it("saves successfully") { expect(created_user).to be_present }
  end

  let(:password) { built_user.password }
  let :user do
    built_user.password = password
    built_user.save
    built_user
  end

  describe "#save" do

    context "new user" do

      it("sets uuid") { expect(created_user.uuid).to be_present } 
      it("sets actv_code") { expect(created_user.actv_code).to be_present }
      it("sets password") { expect(created_user.password).to be_present }

      it "encrypts password" do 
        
        expect(BCrypt::Password.new(user.password)).to eq(password)
      end
    end

    context "created user" do

      it("doesn't change uuid") { expect{ created_user.save }.to_not change{ created_user.uuid } }

      context "password changed" do

        it "encrypts new password" do

          new_password = Faker::Lorem.characters(20)
          created_user.password = new_password
          expect(created_user.save).to be_true
          expect(BCrypt::Password.new(created_user.password)).to eq(new_password)
        end
      end
    end
  end

  describe "#confirmed?" do

    context "new user" do 

      it("returns false") { expect(built_user.confirmed?).to be_false }
    end

    context "persisted user" do

      context "confirmation code blank" do
        
        it "returns true" do

          created_user.actv_code = nil
          created_user.save;
          expect(created_user.confirmed?).to be_true
        end
      end

      context "confirmation code present" do

        it("returns false") { expect(created_user.confirmed?).to be_false }
      end
    end
  end

  describe "#confirm!" do

    context "new user" do

      it("returns false") { expect(built_user.confirm!).to be_false }
    end
    
    context "persisted user" do

      context "confirmation code blank" do

        it "returns false" do

          created_user.actv_code = nil
          created_user.save
          expect(created_user.confirm!).to be_false
        end
      end

      context "confirmation code present" do 

        it "returns true" do

          expect(created_user.confirm!).to be_true
        end

        it "clears the activation code" do

          created_user.confirm!
          expect(created_user.actv_code).to be_blank
        end
      end
    end
  end

  describe ".authenticate" do

    context "non-matching uuid" do

      it("returns nil") { expect(User.authenticate(random_string, random_string)).to be_nil }
    end

    context "unconfirmed user" do

      it("returns nil") { expect(User.authenticate(user.uuid, password)).to be_nil }
    end

    context "non-matching password" do

      it("returns nil") { expect(User.authenticate(user.uuid, random_string)).to be_nil }
    end

    context "matching uuid, matching password, confirmed user" do

      it "returns the user" do
        
        user.confirm!
        expect(User.authenticate(user.uuid, password)).to eq(user)
      end
    end
  end
end
