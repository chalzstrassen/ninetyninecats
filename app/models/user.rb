class User < ActiveRecord::Base
  validates :user_name, presence: true
  validates :password_digest, presence: { message: "Password can't be blank" }
  validates :password, presence: true, length: { minimum: 6, allow_nil: true }
  validates :session_token, presence: true, uniqueness: true

  after_initialize { self.reset_session_token! }
  attr_reader :password

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    return nil if user.nil?
    user.is_password?(password) ? user : nil
  end

  def reset_session_token!
    self.session_token ||= SecureRandom.urlsafe_base64(16)
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end
end
