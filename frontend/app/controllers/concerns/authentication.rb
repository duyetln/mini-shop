module Authentication
  def current_user
    session[:user]
  end

  def current_user=(user)
    session[:user] = user
  end

  def logged_in?
    current_user.present?
  end

  def logged_out?
    !logged_in?
  end

  def log_in!(user)
    self.current_user = user
  end

  def log_out!
    self.current_user = nil
  end
end
