require "spec_helper"

describe UsersSvc do

  def user_response_options
    { except: [:password, :updated_at]  }
  end

  let(:args) { [ :user ] }

  describe "get /users/:id" do

    context "valid id" do

      it "returns the user" do

        get "/users/#{saved_model.id}"
        expect_status(200)
        expect(parsed_result[:id]).to eq(saved_model.id)
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

        expect{ post "/users", new_model.attributes }.to change{ User.count }.by(1)
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

        expect(User).to receive(:new).with(an_instance_of(Hash)).and_return(new_model)
        expect(new_model).to receive(:valid?).and_return(true)
        expect(new_model).to receive(:save).and_return(false)

        expect{ post "/users", new_model.attributes }.to_not change{ User.count }
        expect_status(500)
      end
    end
  end

  describe "post /users/authenticate" do

    let(:password) { new_model.password }
    let(:uuid) { user.uuid }
    let :user do
      new_model.password = password
      new_model.save
      new_model
    end

    context "user authenticated" do

      it "returns the user" do
        
        user.confirm!
        post "/users/authenticate", { uuid: uuid, password: password }
        expect_status(200)
        expect(parsed_result[:uuid]).to eq(uuid)
      end
    end

    context "user not authenticated" do

      context("not confirmed")  { it("returns 404 status") {                post "/users/authenticate", { uuid: uuid,          password: password };       expect_status(404); expect_empty_response } }
      context("wrong uuid")     { it("returns 404 status") { user.confirm!; post "/users/authenticate", { uuid: random_string, password: password };       expect_status(404); expect_empty_response } }
      context("wrong password") { it("returns 404 status") { user.confirm!; post "/users/authenticate", { uuid: uuid,          password: random_string };  expect_status(404); expect_empty_response } }
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
            put "/users/#{saved_model.id}", first_name: nil
            saved_model.reload 
          }.to_not change{ saved_model }
          expect_status(400)
        end
      end

      context "valid parameters" do

        let(:new_password) { random_string }
        let(:new_first_name) { "John" }

        it "returns the user" do

          put "/users/#{saved_model.id}", password: new_password, first_name: new_first_name
          saved_model.reload
          expect_status(200)
          expect(parsed_result[:uuid]).to eq(saved_model.uuid)
          expect(saved_model.first_name).to eq(new_first_name)
          expect(BCrypt::Password.new(saved_model.password)).to eq(new_password)
        end
      end
    end
  end

  describe "put /users/:uuid/confirm/:actv_code" do

    context "user not found" do

      it "returns 404 status" do

        put "/users/#{random_string}/confirm/#{saved_model.actv_code}"
        saved_model.reload
        expect_status(404)
        expect(saved_model).to_not be_confirmed
      end
    end

    context "user found" do

      context "confirmed user" do 

        it "returns 404 status" do
        
          saved_model.confirm!

          put "/users/#{saved_model.uuid}/confirm/#{saved_model.actv_code}"
          saved_model.reload
          expect_status(404)
          expect(saved_model).to be_confirmed
        end
      end

      context "wrong confirmation code" do 

        it "returns 404 status" do 

          put "/users/#{saved_model.uuid}/confirm/#{random_string}"
          saved_model.reload
          expect_status(404)
          expect(saved_model).to_not be_confirmed
        end
      end

      context "correct confirmation code" do 

        it "returns the user" do

          put "/users/#{saved_model.uuid}/confirm/#{saved_model.actv_code}"
          saved_model.reload
          expect_status(200)
          expect(parsed_result[:uuid]).to eq(saved_model.uuid)
          expect(saved_model).to be_confirmed
        end
      end
    end
  end
end