class ApplicationController < ActionController::Base
  include SessionsHelper, ApplicationHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private 
    def require_login
      unless signed_in?
        flash[:error] = 'You must be logged in to access this page'
        redirect_to login_url
      end
    end
end
