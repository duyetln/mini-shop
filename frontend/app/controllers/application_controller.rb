class ApplicationController < ActionController::Base
  include BackendClient
  include Authentication
  include FormParameters
  include Shopping

  before_action :load_data

  helper Authentication

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from BackendClient::APIError do |error|
    flash[:error] = error.meta.present? ? error.meta : error.message
    go_back(error.is_a?(::BackendClient::NotFound) ? root_path : :back)
  end

  rescue_from BackendClient::RequestError do
    flash[:error] = 'Something is broken. Please try again'
    go_back root_path
  end

  rescue_from ActionController::ParameterMissing do |error|
    flash[:error] = 'Please fill out all required fields'
    go_back
  end

  protected

  def load_data
    @currencies = currencies
    @currency = current_currency
    @user = current_user
    @cart = current_cart

    if logged_in?
      @payment_methods = @user.payment_methods
      @addresses = @user.addresses
    end
  end

  def go_back(back = nil)
    redirect_to (back || params[:back] || :back)
  end
end
