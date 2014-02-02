require "spec_helper"

describe UsersService do

  def accessible_attributes(record)
    record.attributes.slice *record.class.accessible_attributes.to_a
  end

  def user_response_options
    { except: [:password, :updated_at]  }
  end

  describe "get /users/:id" do

    before(:all) { @user = FactoryGirl.create :user }

    context "user found" do

      it "should return the user" do
        get "/users/#{@user.id}"
        expect(last_response.status).to eq(200)
        expect(last_response.body).to   eq(@user.to_json(user_response_options))
      end
    end

    context "user not found" do

      it "should return 404 status" do
        get "/users/#{random_string}"
        expect(last_response.status).to eq(404)
      end
    end
  end

  describe "post /users" do

    before(:each) { @user = FactoryGirl.build :user }
    
    context "user created" do

      it "should return the user" do
        post "/users", accessible_attributes(@user)
        expect(last_response.status).to eq(200)
        expect(last_response.body).to be_present
        uuid = Yajl::Parser.parse(last_response.body, symbolize_keys: true)[:user][:uuid]
        expect(User.find_by_uuid(uuid)).to be_present
      end
    end

    context "user not created" do

      context "invalid input" do

        it "should return 400 status" do

          previous_count = User.count
          user_hash  = accessible_attributes(@user)

          post "/users", user_hash.except(user_hash.keys.sample)
          expect(last_response.status).to eq(400)
          expect(User.count).to eq(previous_count)
        end
      end

      context "valid input" do

        it "should return 500 status" do

          previous_count = User.count
          user_hash  = accessible_attributes(@user)
          expect(User).to receive(:new).with(user_hash.as_json).and_return(@user)
          expect(@user).to receive(:valid?).and_return(true)
          expect(@user).to receive(:save).and_return(false)

          post "/users", user_hash
          expect(last_response.status).to eq(500)
          expect(User.count).to eq(previous_count)
        end
      end
    end
  end

  describe "post /users/authenticate" do

    before :each do
      @user = FactoryGirl.build :user
      @password = @user.password
      @user.save
    end

    context "user authenticated" do

      it "should return the user" do
        @user.confirm!
        post "/users/authenticate", { uuid: @user.uuid, password: @password }
        expect(last_response.status).to eq(200)
        expect(last_response.body).to be_present

        uuid = Yajl::Parser.parse(last_response.body, symbolize_keys: true)[:user][:uuid]
        expect(uuid).to eq(@user.uuid)
      end
    end

    context "user not authenticated" do
      context("not confirmed")  { it("should return 404 status") {                     post "/users/authenticate", { uuid: @user.uuid, password: @password };     expect(last_response.status).to eq(404) } }
      context("wrong uuid")     { it("should return 404 status") { @user.confirm!; post "/users/authenticate", { uuid: random_string,  password: @password };     expect(last_response.status).to eq(404) } }
      context("wrong password") { it("should return 404 status") { @user.confirm!; post "/users/authenticate", { uuid: @user.uuid, password: random_string }; expect(last_response.status).to eq(404) } }
    end

  end

  describe "put /users/:id" do

    before :each do
      @user = FactoryGirl.build :user
      @password = @user.password
      @user.save
    end

    context("user not found") { it("should return 404 status") { put "/users/#{random_string}"; expect(last_response.status).to eq(404) } }
    context "user found" do

      context "invalid input" do

        it "should return 400 status" do
          user_hash = accessible_attributes(@user)
          user_hash[user_hash.keys.sample] = nil
          put "/users/#{@user.id}", user_hash
          expect(last_response.status).to eq(400)
          @user.reload
          expect(accessible_attributes(@user)).to eq(accessible_attributes(User.find_by_uuid(@user.uuid)))
        end
      end

      context "valid input" do

        it "should return the user" do
          user_hash = accessible_attributes(@user)
          new_password   = random_string
          new_first_name = random_string.gsub(/\d/,"")
          user_hash["password"]   = new_password
          user_hash["first_name"] = new_first_name

          put "/users/#{@user.id}", user_hash.slice("password", "first_name")
          expect(last_response.status).to eq(200)
          expect(last_response.body).to be_present

          uuid = Yajl::Parser.parse(last_response.body, symbolize_keys: true)[:user][:uuid]
          updated_user = User.find_by_uuid(uuid)
          expect(updated_user.first_name).to eq(new_first_name)
          expect(BCrypt::Password.new updated_user.password).to eq(new_password)
        end
      end
    end
  end

  describe "put /users/:uuid/confirm/:confirmation_code" do

    before :each do
      @user = FactoryGirl.create :user
      @uuid              = @user.uuid
      @confirmation_code = @user.confirmation_code
    end

    def ensure_confirmation_status(status)
      @user.reload
      expect(@user.confirmed?).to eq(status)
    end

    context("user not found") { it("should return 404 status") { put "/users/#{random_string}/confirm/#{@confirmation_code}"; expect(last_response.status).to eq(404); ensure_confirmation_status(false) } }
    context "user found" do

      context("confirmed user")            { it("should return 404 status") { @user.confirm!; put "/users/#{@uuid}/confirm/#{@confirmation_code}"; expect(last_response.status).to eq(404); ensure_confirmation_status(true) } }
      context("wrong confirmation code")   { it("should return 404 status") {                     put "/users/#{@uuid}/confirm/#{@random_code}";       expect(last_response.status).to eq(404); ensure_confirmation_status(false)} }
      context "correct confirmation code" do 

        it "should return the user" do
          put "/users/#{@uuid}/confirm/#{@confirmation_code}"
          expect(last_response.status).to eq(200)
          expect(last_response.body).to be_present

          uuid = Yajl::Parser.parse(last_response.body, symbolize_keys: true)[:user][:uuid]
          expect(uuid).to eq(@user.uuid)
          ensure_confirmation_status(true)
        end
      end
    end
  end
end