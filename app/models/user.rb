class User < ActiveRecord::Base
  NAME_REGEX = /\A[A-Z][a-zA-Z]+\z/

  def User.gen_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.hash_token(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  before_create :create_remember_token

  validates :fname, presence: true, format: { with: NAME_REGEX }
  validates :lname, presence: true, format: { with: NAME_REGEX }
  validates :email, presence: true, format: { with: /@/ }
  validates :password, presence: true, length: { in: 3..50 }
  has_secure_password

  def full_name
    fname + ' ' + lname
  end

  private
    def create_remember_token
      self.remember_token = User.hash_token(User.gen_remember_token)
    end
  
end
