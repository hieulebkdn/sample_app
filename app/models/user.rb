class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, format: {with: VALID_EMAIL_REGEX},
    length: {maximum: Settings.user_email_maxlen},
    presence: true, uniqueness: {case_sensitive: false}
  validates :password, length: {minimum: Settings.user_password_minlen},
    presence: true
  validates :name, length: {maximum: Settings.user_name_maxlen},
    presence: true

  before_save{email.downcase!}

  has_secure_password
end
