module Accounts
  class UsersController < ApplicationController
    def index
      @users = BackendClient::User.all(pagination)
      render nothing: true
    end

    def show
      @user         = BackendClient::User.find(params.require(:id))
      @purchases    = @user.purchases
      @coupons      = @user.coupons
      @transactions = @user.transactions
      @ownerships   = @user.ownerships
      @shipments    = @user.shipments
      render nothing: true
    end
  end
end
