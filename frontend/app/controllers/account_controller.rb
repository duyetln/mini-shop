class AccountController < ApplicationController
  def create
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

  def update
    redirect_to sign_in_account_path and return unless logged_in?
    @params = params.require(:user).permit(:first_name, :last_name, :email, :birthdate)
    @params[:birthdate] = DateTime.strptime(@params[:birthdate], '%m/%d/%Y')
    @user = current_user
    @user.merge!(@params)
    @user.update!(:first_name, :last_name, :email, :birthdate)
    redirect_to :back
  rescue ArgumentError
    flash[:error] = 'Birthdate must conform to 11/25/2014 format'
    redirect_to :back
  end

  def password
    redirect_to sign_in_account_path and return unless logged_in?
    @params = params.require(:user).permit(:password, :new_password, :new_password_confirmation)
    @user = current_user
    User.authenticate(@user.email, @params.require(:password))

    if @params[:new_password] != @params[:new_password_confirmation]
      flash[:error] = 'Please confirm your new password'
      redirect_to :back and return
    end

    @user.password = @params[:new_password]
    @user.update!(:password)
    redirect_to :back
  rescue BackendClient::Unauthorized
    flash[:error] = 'Invalid password'
    redirect_to :back
  end

  def payment_methods
    redirect_to sign_in_account_path and return unless logged_in?
    @params = params.require(:payment_method).permit(:name, :balance, :currency_id, :billing_address_id)
    @user = current_user
    @user.create_payment_method(@params)
    redirect_to :back
  end

  def addresses
    redirect_to sign_in_account_path and return unless logged_in?
    @params = params.require(:address).permit(:line1, :line2, :line3, :city, :region, :postal_code, :country)
    @user = current_user
    @user.create_address(@params)
    redirect_to :back
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
