class AccountController < ApplicationController
  before_action :sign_in!, only: [:show, :update, :password, :payment_methods, :addresses]

  def create
    @params = create_user_params
    go_back and return unless parse_birthdate
    go_back and return unless confirm_password
    @user = User.create(@params.except(:password_confirmation))
    @user = User.confirm(@user.uuid, @user.actv_code)
    flash[:success] = 'Your account has been created!'
    go_back
  end

  def show
    @purchases = @user.purchases.select(&:committed?)
    @payment_methods = @user.payment_methods
    @addresses = @user.addresses
    @ownerships = @user.ownerships
    @shipments = @user.shipments
    @coupons = @user.coupons
    @promotions = @coupons.map do |coupon|
      coupon.promotion_id
    end.uniq.map do |promotion_id|
      Promotion.find(promotion_id)
    end
  end

  def update
    begin
      @params = update_user_params
      go_back and return unless parse_birthdate
      @user.merge!(@params)
      @user.update!(:first_name, :last_name, :email, :birthdate)
      go_back
    rescue
      @user.reload!
      raise
    end
  end

  def password
    @params = update_password_confirmation
    go_back and return unless confirm_new_password
    User.authenticate(@user.email, @params[:password])
    @user.password = @params[:new_password]
    @user.update!(:password)
    go_back
  rescue BackendClient::Unauthorized
    flash[:error] = 'Please check your password'
    go_back
  end

  def payment_methods
    @user.create_payment_method(create_payment_method_params)
    flash[:success] = 'New payment method has been added to your account'
    go_back
  end

  def addresses
    @user.create_address(create_address_params)
    flash[:success] = 'New address has been added to your account'
    go_back
  end

  def sign_in
    redirect_to account_path if logged_in?
  end

  def sign_up
    redirect_to account_path if logged_in?
  end

  def sign_out
    log_out!
    @cart.payment_method = nil
    @cart.shipping_address = nil
    flash[:info] = 'Hope to see you again soon!'
    redirect_to sign_in_account_path
  end

  def verify
    @params = verify_user_params
    @user = User.authenticate(@params[:email], @params[:password])
    log_in!(@user)
    flash[:success] = "Welcome back, #{@user.first_name}!"
    go_back session[:back]
  rescue BackendClient::Unauthorized, BackendClient::NotFound
    flash[:error] = 'Please check your email or password'
    go_back
  end

  protected

  def parse_birthdate
    @params[:birthdate] = DateTime.strptime(@params[:birthdate], '%m/%d/%Y')
    true
  rescue ArgumentError
    flash[:error] = 'Please follow mm/dd/yyyy format for your birthdate'
    false
  end

  def confirm_password
    @params[:password] == @params[:password_confirmation] ||
    (flash[:error] = 'Please confirm your password') && false
  end

  def confirm_new_password
    @params[:new_password] == @params[:new_password_confirmation] ||
    (flash[:error] = 'Please confirm your new password') && false
  end
end
