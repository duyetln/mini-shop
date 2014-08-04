module Accounts
  class UsersController < ApplicationController
    def index
      @users = resource_class.all(pagination)
    end

    def show
      @user         = resource
      @purchases    = @user.purchases
      @coupons      = @user.coupons
      @transactions = @user.transactions
      @ownerships   = @user.ownerships
      @shipments    = @user.shipments
      render nothing: true
    end

    private

    def set_resource_class
      @resource_class = BackendClient::User
    end
  end
end
