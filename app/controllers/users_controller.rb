class UsersController < ApplicationController
  def new
    @user = User.new
  end

  #Create a new user. Else redirect back to registration and show errors
  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      redirect_to dashboard_index_path
    else
      flash[:danger] = user.errors.full_messages
      redirect_to :back
    end
  end
  private
    def user_params
      params.require(:user).permit(:first_name,:last_name,:email,:password,:password_confirmation)
    end
end
