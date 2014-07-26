class ApplicationController < ActionController::Base
  include PaginationHelper
  include ParamsHelper
  include ResourceHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_resource_class

  def index
    render nothing: true
  end
end
