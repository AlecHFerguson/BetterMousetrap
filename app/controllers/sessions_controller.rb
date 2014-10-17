class SessionsController < ApplicationController

  def index
    redirect_to :login
  end

  def login
    if current_user
      redirect_to({controller: :gadgets})
    end
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_to gadgets_url
    else
      flash[:error] = 'Invalid email or password'
      render 'login'
    end
  end

  def destroy
    sign_out
  end
end
