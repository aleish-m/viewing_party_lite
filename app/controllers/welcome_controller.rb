class WelcomeController < ApplicationController
  before_action :current_user
  def index
    @users = User.all
  end
end
