require "spec_helper"

describe UsersSvc do

  def user_response_options
    { except: [:password, :updated_at]  }
  end

  describe "get /users/:id" do

    context "valid id" do

      it "returns the user" do

        get "/users/#{created_user.id}"
        expect_status(200)
        expect(parsed_result[:id]).to eq(created_user.id)
      end
    end

    context "invalid id" do

      it "returns 404 status" do

        get "/users/#{random_string}"
        expect_status(404)
        expect_empty_response
      end
    end
  end

  describe "post /users" do
    
    context "valid parameters" do

      it "creates the user and returns it" do

        expect{ post "/users", built_user.attributes }.to change{ User.count }.by(1)
        expect_status(200)
        expect(parsed_result[:id]).to eq(User.last.id)
        expect(parsed_result[:uuid]).to eq(User.last.uuid)
      end
    end


    context "missing parameters" do

      it "returns 400 status" do

        expect{ post "/users" }.to_not change{ User.count }
        expect_status(400)
        expect_empty_response
      end
    end

    context "user creation failed" do

      it "returns 500 status" do

        expect(User).to receive(:new).with(an_instance_of(Hash)).and_return(built_user)
        expect(built_user).to receive(:valid?).and_return(true)
        expect(built_user).to receive(:save).and_return(false)

        expect{ post "/users", built_user.attributes }.to_not change{ User.count }
        expect_status(500)
      end
    end
  end

  describe "post /users/authenticate" do

    let(:uuid) { created_user.uuid }
    let(:password) { built_user.password }

    context "user authenticated" do

      it "returns the user" do
        
        created_user.confirm!
        post "/users/authenticate", { uuid: uuid, password: password }
        expect_status(200)
        expect(parsed_result[:uuid]).to eq(uuid)
      end
    end

    context "user not authenticated" do

      context("not confirmed")  { it("returns 404 status") {                        post "/users/authenticate", { uuid: uuid,           password: password };       expect_status(404); expect_empty_response } }
      context("wrong uuid")     { it("returns 404 status") { created_user.confirm!; post "/users/authenticate", { uuid: random_string,  password: password };       expect_status(404); expect_empty_response } }
      context("wrong password") { it("returns 404 status") { created_user.confirm!; post "/users/authenticate", { uuid: uuid,           password: random_string };  expect_status(404); expect_empty_response } }
    end

  end

  describe "put /users/:id" do

    context "user not found" do

      it "returns 404 status" do 

        put "/users/#{random_string}"
        expect_status(404)
        expect_empty_response
      end
    end

    context "user found" do

      context "invalid parameters" do

        it "returns 400 status" do

          expect{ 
            put "/users/#{created_user.id}", first_name: nil
            created_user.reload 
          }.to_not change{ created_user }
          expect_status(400)
        end
      end

      context "valid parameters" do

        let(:new_password) { random_string }
        let(:new_first_name) { "John" }

        it "returns the user" do

          put "/users/#{created_user.id}", password: new_password, first_name: new_first_name
          created_user.reload
          expect_status(200)
          expect(parsed_result[:uuid]).to eq(created_user.uuid)
          expect(created_user.first_name).to eq(new_first_name)
          expect(BCrypt::Password.new(created_user.password)).to eq(new_password)
        end
      end
    end
  end

  describe "put /users/:uuid/confirm/:confirmation_code" do

    context "user not found" do

      it "returns 404 status" do

        put "/users/#{random_string}/confirm/#{created_user.confirmation_code}"
        created_user.reload
        expect_status(404)
        expect(created_user).to_not be_confirmed
      end
    end

    context "user found" do

      context "confirmed user" do 

        it "returns 404 status" do
        
          created_user.confirm!

          put "/users/#{created_user.uuid}/confirm/#{created_user.confirmation_code}"
          created_user.reload
          expect_status(404)
          expect(created_user).to be_confirmed
        end
      end

      context "wrong confirmation code" do 

        it "returns 404 status" do 

          put "/users/#{created_user.uuid}/confirm/#{random_string}"
          created_user.reload
          expect_status(404)
          expect(created_user).to_not be_confirmed
        end
      end

      context "correct confirmation code" do 

        it "returns the user" do

          put "/users/#{created_user.uuid}/confirm/#{created_user.confirmation_code}"
          created_user.reload
          expect_status(200)
          expect(parsed_result[:uuid]).to eq(created_user.uuid)
          expect(created_user).to be_confirmed
        end
      end
    end
  end
end