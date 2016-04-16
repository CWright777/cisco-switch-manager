class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  def angular
    render 'layouts/application'
  end

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

  def snmp_walk creds, table_columns, &block
    SNMP::Manager.open(
      host: creds[:host],
      community: creds[:community]
    ) do |manager|
      manager.walk(table_columns) do |row|
        yield row
      end
    end
  end

  helper_method :current_user, :active_icon,:snmp_walk
end
