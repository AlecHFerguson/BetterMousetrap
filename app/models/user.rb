class User < ActiveRecord::Base
  has_many :comments
  validates_associated :comments
  has_many :votes
  validates_associated :votes

  # Only permit alphabetic characters
  NAME_REGEX     = /\A[a-zA-Z]+\z/
  EMAIL_REGEX    = /\A[^@]{5,50}@[^@]{3,50}\.[^@]{1,5}\z/
  NAME_MESSAGE   = 'First name can only contain letters'
  EMAIL_MESSAGE  = 'Please enter a valid email address'

  def User.gen_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.hash_token(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  before_create :create_remember_token

  validates :fname, presence: true, length: { in: 3..90 }, 
                format: { with: NAME_REGEX, message: NAME_MESSAGE }
  validates :lname, presence: true, length: { in: 3..90 },
                format: { with: NAME_REGEX, message: NAME_MESSAGE }
  validates :email, presence: true, format: { with: EMAIL_REGEX, message: EMAIL_MESSAGE }
  validates :password, presence: true, length: { in: 3..50 }
  has_secure_password

  def fname=(name)
    if name.nil? || name == ''
      super name
    else
      super name[0].upcase + name[1..-1].downcase
    end
  end

  def lname=(name)
    if name.nil? || name == ''
      super name
    else
      super name[0].upcase + name[1..-1].downcase
    end
  end

  def full_name
    fname + ' ' + lname
  end

  private
    def create_remember_token
      self.remember_token = User.hash_token(User.gen_remember_token)
    end
  
end
