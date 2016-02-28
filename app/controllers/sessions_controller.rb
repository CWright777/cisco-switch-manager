class SessionsController < ApplicationController
  def index
    @session = User.new
  end

  #Create session from successful login or redirect back to login page
  def create
    user = User.find_by_email(params[:user][:email].downcase)
    if user && user.authenticate(params[:user][:password])
      session[:user_id] = user.id
      redirect_to dashboard_index_path
    else
      flash[:danger] = "Invalid email/password combo"
      redirect_to :back
    end
  end
end
