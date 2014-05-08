require 'services/base'
require 'models/serializers/accounts'

module Services
  module Accounts
    class Users < Services::Base
      get '/users/:id' do
        process_request do
          user = User.find(params[:id])
          respond_with(UserSerializer.new(user))
        end
      end

      post '/users' do
        process_request do
          user = User.new(params[:user])
          user.save!
          respond_with(UserSerializer.new(user))
        end
      end

      post '/users/authenticate' do
        process_request do
          user = User.authenticate!(
            params[:email],
            params[:password]
          ) || unauthorized!
          respond_with(UserSerializer.new(user))
        end
      end

      put '/users/:id' do
        process_request do
          user = User.find(params[:id])
          user.update_attributes!(params[:user])
          respond_with(UserSerializer.new(user))
        end
      end

      put '/users/:uuid/confirm/:actv_code' do
        process_request do
          user = User.confirm!(params[:uuid], params[:actv_code])
          respond_with(UserSerializer.new(user))
        end
      end
    end
  end
end
