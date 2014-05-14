require 'services/base'
require 'services/serializers/accounts'

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
          user = User.new(user_params)
          user.save!
          respond_with(UserSerializer.new(user))
        end
      end

      post '/users/authenticate' do
        process_request do
          user = User.authenticate!(
            user_params[:email],
            user_params[:password]
          ) || unauthorized!
          respond_with(UserSerializer.new(user))
        end
      end

      put '/users/:id' do
        process_request do
          user = User.find(params[:id])
          user.update_attributes!(user_params)
          respond_with(UserSerializer.new(user))
        end
      end

      put '/users/:uuid/confirm/:actv_code' do
        process_request do
          user = User.confirm!(params[:uuid], params[:actv_code])
          respond_with(UserSerializer.new(user))
        end
      end

      protected

      def user_params
        params[:user] || {}
      end
    end
  end
end
