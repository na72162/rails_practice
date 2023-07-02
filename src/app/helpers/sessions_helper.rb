module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
    session[:session_token] = user.session_token
  end

  def log_out
    forget(current_user)
    reset_session
    @current_user = nil
  end
end
