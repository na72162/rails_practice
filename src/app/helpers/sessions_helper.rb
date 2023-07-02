module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
    session[:session_token] = user.session_token
  end
end
