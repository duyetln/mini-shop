class CustomersService < Sinatra::Base

  before { content_type :json }

  get "/customers/:uuid" do
    customer = load_customer
    customer.present? ? customer.to_json(customer_response_options) : error(404)
  end

  post "/customers" do
    customer = Customer.new(accessible_params)
    customer.save ? customer.to_json(customer_response_options) : error(500)
  end

  post "/customers/authenticate" do
    customer = Customer.authenticate(params[:uuid], params[:password])
    customer.present? ? customer.to_json(customer_response_options) : error(404)
  end

  put "/customers/:uuid" do
    customer = load_customer
    customer.present? ? ( customer.update_attributes(accessible_params) ? customer.to_json(customer_response_options) : error(500) ) : error(404)
  end

  put "/customers/:uuid/confirm/:confirmation_code" do
    customer = load_customer
    customer.present? && !customer.confirmed? && customer.confirmation_code == params[:confirmation_code] ? ( customer.confirm! ? customer.to_json(customer_response_options) : error(500) ) : error(404)
  end

  protected 

  def customer_response_options
    { except: [:id, :password, :updated_at]  }
  end 

  def load_customer
    Customer.find_by_uuid(params[:uuid])
  end

  def accessible_params
    params.slice *Customer.accessible_attributes.to_a
  end

end