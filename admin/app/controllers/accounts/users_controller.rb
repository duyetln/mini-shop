module Accounts
  class UsersController < ApplicationController
    def index
      @users = User.all
    end

    def show
      @user = User.find(id)
      @purchases = @user.purchases
      @coupons = @user.coupons
      @ownerships = @user.ownerships
      @shipments = @user.shipments
    end
  end
end
