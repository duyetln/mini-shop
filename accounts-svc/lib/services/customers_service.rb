class CustomersService < Sinatra::Base

  before { content_type :json }

  helpers do

    protected 

    def find_customer_by_id!
      @customer = Customer.find_by_id(params[:id]) || halt(404)
    end

    def find_customer_by_uuid!
      @customer = Customer.find_by_uuid(params[:uuid]) || halt(404)
    end

    def customer_response_options
      { except: [:password, :updated_at] }
    end

    def load_customer!
      @customer = Customer.new(accessible_params)
      @customer.valid? && @customer || halt(400)
    end

    def accessible_params
      params.slice *Customer.accessible_attributes.to_a
    end

    def respond_with(resource, response_options={}, json_options=customer_response_options)
      resource.present? || halt(404)
      status = block_given? ? yield(resource) : resource
      success_code = response_options[:success] || 200
      failure_code = response_options[:failure] || 500
      status ? halt(success_code, resource.to_json(json_options)) : halt(failure_code)
    end

  end

  get "/customers/:id" do
    find_customer_by_id!
    respond_with(@customer)
  end

  post "/customers" do
    load_customer!
    respond_with(@customer) { |c| c.save }
  end

  post "/customers/authenticate" do
    @customer = Customer.authenticate(params[:uuid], params[:password])
    respond_with(@customer)
  end

  put "/customers/:id" do
    find_customer_by_id!
    respond_with(@customer, failure: 400) { |c| c.update_attributes(accessible_params) }
  end

  put "/customers/:uuid/confirm/:confirmation_code" do
    find_customer_by_uuid!
    !@customer.confirmed? && @customer.confirmation_code == params[:confirmation_code] || halt(404)
    respond_with(@customer) { |c| c.confirm! }
  end

end