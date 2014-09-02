class ApplicationController < ActionController::Base
  include BackendClient

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from BackendClient::APIError do |error|
    flash[:error] = error.meta.present? ? error.meta : error.message
    redirect_to :back
  end

  rescue_from BackendClient::RequestError do |error|
    flash[:error] = 'Something unexpected occurred while sending the request. Please contact techincal support'
    redirect_to :back
  end

  def index
  end

  protected

  def id
    params.require(:id)
  end

  def update_resource(resource, update_params)
    resource.merge!(update_params)
    resource.update!(*update_params.keys)
    resource
  end
end
