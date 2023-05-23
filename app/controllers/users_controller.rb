class UsersController < ApplicationController
  def show
    require_user
  end

  def new
    @new_user = User.new
  end

  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      current_user
      redirect_to dashboard_path
    else
      flash.alert = user.errors.full_messages.to_sentence
      redirect_to register_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
