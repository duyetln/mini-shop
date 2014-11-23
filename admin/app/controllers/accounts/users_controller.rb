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
      @promotions = @coupons.map do |coupon|
        coupon.promotion_id
      end.uniq.map do |promotion_id|
        Promotion.find(promotion_id)
      end
    end
  end
end
