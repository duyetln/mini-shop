class AccountController < ApplicationController
  def create
    begin
      @params = params.require(:user).permit(:first_name, :last_name, :email, :birthdate, :password, :password_confirmation)
      @params[:birthdate] = DateTime.strptime(@params[:birthdate], '%m/%d/%Y')

      if @params[:password] != @params[:password_confirmation]
        flash[:error] = 'Please confirm your password'
        redirect_to :back and return
      end

      @user = User.create(@params.except(:password_confirmation))
      @user = User.confirm(@user.uuid, @user.actv_code)
      log_in!(@user)
      flash[:success] = 'User created'
      redirect_to :back
    rescue ArgumentError
      flash[:error] = 'Birthdate must conform to 11/25/2014 format'
      redirect_to :back
    end
  end

  def show
    redirect_to sign_in_account_path and return unless logged_in?
    @user = current_user
    @purchases = @user.purchases
    @coupons = @user.coupons
    @ownerships = @user.ownerships
    @shipments = @user.shipments
    @currencies = Currency.all

    @promotions = []
    @coupons.each do |coupon|
      unless @promotions.find { |promotion| promotion.id == coupon.promotion_id }
        @promotions << coupon.promotion
      end
    end
  end

  def sign_in
    redirect_to account_path and return unless logged_out?
  end

  def sign_up
    redirect_to account_path and return unless logged_out?
  end

  def sign_out
    log_out!
    redirect_to sign_in_account_path
  end

  def verify
    begin
      @params = params.require(:user).permit(:email, :password)
      @user = User.authenticate(@params[:email], @params[:password])
      log_in!(@user)
      flash[:success] = 'Welcome back!'
      redirect_to :back
    rescue BackendClient::Unauthorized, BackendClient::NotFound
      flash[:error] = 'Invalid email or password'
      redirect_to :back
    end
  end
end
