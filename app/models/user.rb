class User < ApplicationRecord
  has_many :feedbacks
  has_many :orders

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true, length: {maximum: Settings.name_max_length}
  validates :email, presence: true,
    length: {maximum: Settings.email_max_length},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, presence: true, allow_nil: true,
    length: {minimum: Settings.password_min_length}

  has_secure_password

  before_save :downcase_email

  def current_product? product
    self == product
    
  def current_user? user
    self == user
  end

  private

  def downcase_email
    email.downcase!
  end
end
