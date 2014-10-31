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

  def sign_in!
    if logged_out?
      session[:back] = request.fullpath if request.get?
      redirect_to sign_in_account_path
    end
  end
end
