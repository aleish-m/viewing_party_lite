class ApplicationController < ActionController::Base
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_user
    return if current_user

    flash[:error] = 'Please log in to access the requested page'
    redirect_back fallback_location: root_path
  end
end
