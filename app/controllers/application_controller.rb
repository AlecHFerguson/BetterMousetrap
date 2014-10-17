class ApplicationController < ActionController::Base
  include SessionsHelper, ApplicationHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected
    def require_login(error_msg = 'You must be logged in to access this page')
      unless signed_in?
        flash[:error] = error_msg
        redirect_to login_url
      end
    end
end
