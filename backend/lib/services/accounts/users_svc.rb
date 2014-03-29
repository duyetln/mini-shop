class UsersSvc < Sinatra::Base

  before { content_type :json }

  helpers do

    protected 

    def find_user_by_id!
      @user = User.find_by_id(params[:id]) || halt(404)
    end

    def find_user_by_uuid!
      @user = User.find_by_uuid(params[:uuid]) || halt(404)
    end

    def user_response_options
      { root: false, except: [:password, :updated_at] }
    end

    def load_user!
      @user = User.new(accessible_params)
      @user.valid? && @user || halt(400)
    end

    def accessible_params
      params.slice *User.column_names
    end

    def respond_with(resource, response_options={}, json_options=user_response_options)
      resource.present? || halt(404)
      status = block_given? ? yield(resource) : resource
      success_code = response_options[:success] || 200
      failure_code = response_options[:failure] || 500
      status ? halt(success_code, resource.to_json(json_options)) : halt(failure_code)
    end

  end

  get '/users/:id' do
    find_user_by_id!
    respond_with(@user)
  end

  post '/users' do
    load_user!
    respond_with(@user) { |c| c.save }
  end

  post '/users/authenticate' do
    @user = User.authenticate(params[:uuid], params[:password])
    respond_with(@user)
  end

  put '/users/:id' do
    find_user_by_id!
    respond_with(@user, failure: 400) { |c| c.update_attributes(accessible_params) }
  end

  put '/users/:uuid/confirm/:actv_code' do
    find_user_by_uuid!
    !@user.confirmed? && @user.actv_code == params[:actv_code] || halt(404)
    respond_with(@user) { |c| c.confirm! }
  end

end