class SessionController < ApplicationController 
  def new
    @user = User.new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to dashboard_path
    else
      redirect_to login_path
      flash.alert = "Invaild email or password"
    end
  end

  def destroy
    session.delete(:user_id)
    flash[:notice] = "You have successfully logged out."
    redirect_to root_path
  end
end
