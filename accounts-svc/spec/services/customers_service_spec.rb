require "spec_helper"

describe CustomersService do

  def accessible_attributes(record)
    record.attributes.slice *record.class.accessible_attributes.to_a
  end

  def customer_response_options
    { except: [:password, :updated_at]  }
  end

  describe "get /customers/:id" do

    before(:all) { @customer = FactoryGirl.create :customer }

    context "customer found" do

      it "should return the customer" do
        get "/customers/#{@customer.id}"
        expect(last_response.status).to eq(200)
        expect(last_response.body).to   eq(@customer.to_json(customer_response_options))
      end
    end

    context "customer not found" do

      it "should return 404 status" do
        get "/customers/#{random_string}"
        expect(last_response.status).to eq(404)
      end
    end
  end

  describe "post /customers" do

    before(:each) { @customer = FactoryGirl.build :customer }
    
    context "customer created" do

      it "should return the customer" do
        post "/customers", accessible_attributes(@customer)
        expect(last_response.status).to eq(200)
        expect(last_response.body).to be_present
        uuid = Yajl::Parser.parse(last_response.body, symbolize_keys: true)[:customer][:uuid]
        expect(Customer.find_by_uuid(uuid)).to be_present
      end
    end

    context "customer not created" do

      context "invalid input" do

        it "should return 400 status" do

          previous_count = Customer.count
          customer_hash  = accessible_attributes(@customer)

          post "/customers", customer_hash.except(customer_hash.keys.sample)
          expect(last_response.status).to eq(400)
          expect(Customer.count).to eq(previous_count)
        end
      end

      context "valid input" do

        it "should return 500 status" do

          previous_count = Customer.count
          customer_hash  = accessible_attributes(@customer)
          expect(Customer).to receive(:new).with(customer_hash.as_json).and_return(@customer)
          expect(@customer).to receive(:valid?).and_return(true)
          expect(@customer).to receive(:save).and_return(false)

          post "/customers", customer_hash
          expect(last_response.status).to eq(500)
          expect(Customer.count).to eq(previous_count)
        end
      end
    end
  end

  describe "post /customers/authenticate" do

    before :each do
      @customer = FactoryGirl.build :customer
      @password = @customer.password
      @customer.save
    end

    context "customer authenticated" do

      it "should return the customer" do
        @customer.confirm!
        post "/customers/authenticate", { uuid: @customer.uuid, password: @password }
        expect(last_response.status).to eq(200)
        expect(last_response.body).to be_present

        uuid = Yajl::Parser.parse(last_response.body, symbolize_keys: true)[:customer][:uuid]
        expect(uuid).to eq(@customer.uuid)
      end
    end

    context "customer not authenticated" do
      context("not confirmed")  { it("should return 404 status") {                     post "/customers/authenticate", { uuid: @customer.uuid, password: @password };     expect(last_response.status).to eq(404) } }
      context("wrong uuid")     { it("should return 404 status") { @customer.confirm!; post "/customers/authenticate", { uuid: random_string,  password: @password };     expect(last_response.status).to eq(404) } }
      context("wrong password") { it("should return 404 status") { @customer.confirm!; post "/customers/authenticate", { uuid: @customer.uuid, password: random_string }; expect(last_response.status).to eq(404) } }
    end

  end

  describe "put /customers/:id" do

    before :each do
      @customer = FactoryGirl.build :customer
      @password = @customer.password
      @customer.save
    end

    context("user not found") { it("should return 404 status") { put "/customers/#{random_string}"; expect(last_response.status).to eq(404) } }
    context "user found" do

      context "invalid input" do

        it "should return 400 status" do
          customer_hash = accessible_attributes(@customer)
          customer_hash[customer_hash.keys.sample] = nil
          put "/customers/#{@customer.id}", customer_hash
          expect(last_response.status).to eq(400)
          @customer.reload
          expect(accessible_attributes(@customer)).to eq(accessible_attributes(Customer.find_by_uuid(@customer.uuid)))
        end
      end

      context "valid input" do

        it "should return the customer" do
          customer_hash = accessible_attributes(@customer)
          new_password   = random_string
          new_first_name = random_string.gsub(/\d/,"")
          customer_hash["password"]   = new_password
          customer_hash["first_name"] = new_first_name

          put "/customers/#{@customer.id}", customer_hash.slice("password", "first_name")
          expect(last_response.status).to eq(200)
          expect(last_response.body).to be_present

          uuid = Yajl::Parser.parse(last_response.body, symbolize_keys: true)[:customer][:uuid]
          updated_customer = Customer.find_by_uuid(uuid)
          expect(updated_customer.first_name).to eq(new_first_name)
          expect(BCrypt::Password.new updated_customer.password).to eq(new_password)
        end
      end
    end
  end

  describe "put /customers/:uuid/confirm/:confirmation_code" do

    before :each do
      @customer = FactoryGirl.create :customer
      @uuid              = @customer.uuid
      @confirmation_code = @customer.confirmation_code
    end

    def ensure_confirmation_status(status)
      @customer.reload
      expect(@customer.confirmed?).to eq(status)
    end

    context("user not found") { it("should return 404 status") { put "/customers/#{random_string}/confirm/#{@confirmation_code}"; expect(last_response.status).to eq(404); ensure_confirmation_status(false) } }
    context "user found" do

      context("confirmed user")            { it("should return 404 status") { @customer.confirm!; put "/customers/#{@uuid}/confirm/#{@confirmation_code}"; expect(last_response.status).to eq(404); ensure_confirmation_status(true) } }
      context("wrong confirmation code")   { it("should return 404 status") {                     put "/customers/#{@uuid}/confirm/#{@random_code}";       expect(last_response.status).to eq(404); ensure_confirmation_status(false)} }
      context "correct confirmation code" do 

        it "should return the user" do
          put "/customers/#{@uuid}/confirm/#{@confirmation_code}"
          expect(last_response.status).to eq(200)
          expect(last_response.body).to be_present

          uuid = Yajl::Parser.parse(last_response.body, symbolize_keys: true)[:customer][:uuid]
          expect(uuid).to eq(@customer.uuid)
          ensure_confirmation_status(true)
        end
      end
    end
  end
end