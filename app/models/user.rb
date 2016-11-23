class User < ApplicationRecord
  before_save { self.email = email.downcase }
  validates :username,  presence: true,
                        length: { maximum: 50 },
                        uniqueness: { case_sensitive: false }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true,
                    length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }
  has_many :bucketlists

  before_save :generate_serial_no

  private

  def generate_serial_no
    invalid_number = serial_no
    self.serial_no = rand(100..999).to_s while serial_no == invalid_number
  end
end
