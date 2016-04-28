class SessionsController < Devise::SessionsController
  after_filter :set_csrf_headers, only: [:create, :destroy]

  #Create new CSRF token on logout
  protected
  def set_csrf_headers
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?  
  end
end
