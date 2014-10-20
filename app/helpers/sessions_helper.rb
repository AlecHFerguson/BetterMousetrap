module SessionsHelper
  def sign_in(user)
    remember_token = User.gen_remember_token
    cookies.permanent[:remember_token] = { value: remember_token, 
                                           expires: 30.minutes.from_now.utc }
    user.update_attribute(:remember_token, User.hash_token(remember_token))
    self.current_user = user
  end

  def sign_out
    token_hash = User.hash_token(cookies[:remember_token])
    user = User.find_by(remember_token: token_hash)
    if user
      user.update_attribute(:remember_token, nil)
    end
    cookies.delete :remember_token
    self.current_user = nil
    render 'login'
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= current_user!
  end

  def current_user!
    remember_token = User.hash_token(cookies[:remember_token])
    @current_user = User.find_by(remember_token: remember_token)
  end
end