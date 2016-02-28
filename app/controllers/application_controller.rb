class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end
  
  def active_icon status
    if status == "active"
      icon = "thumb_up"
    else
      icon = "thumb_down"
    end
    "<i class='material-icons'>#{icon}</i>"
  end
  helper_method :current_user, :active_icon
end
