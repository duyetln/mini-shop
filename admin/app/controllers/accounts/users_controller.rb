module Accounts
  class UsersController < ApplicationController
    def index
      @users = resource_class.all(sort: :desc)
    end

    def show
      @user         = resource
      @purchases    = @user.purchases.sort { |a,b| b.id <=> a.id }
      @coupons      = @user.coupons.sort { |a,b| b.id <=> a.id }
      @ownerships   = @user.ownerships.sort { |a,b| b.id <=> a.id }
      @shipments    = @user.shipments.sort { |a,b| b.id <=> a.id }
    end

    private

    def set_resource_class
      @resource_class = BackendClient::User
    end
  end
end
