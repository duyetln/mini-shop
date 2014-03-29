class User < ActiveRecord::Base
  attr_protected :uuid, :actv_code
  attr_readonly :uuid

  validates :first_name, presence: true
  validates :last_name,  presence: true
  validates :email,      presence: true
  validates :birthdate,  presence: true
  validates :password,   presence: true

  validates :first_name, format: { with: /\A[a-zA-Z]+\z/ }
  validates :last_name,  format: { with: /\A[a-zA-Z]+\z/ }
  validates :email,      format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ }

  validates :email, uniqueness: true
  validates :password, length: { minimum: 5 }

  after_initialize :initialize_values
  before_save :encrypt_password, if: :password_changed?

  def self.authenticate(uuid, password)
    user = find_by_uuid(uuid)
    user.present? && user.confirmed? && BCrypt::Password.new(user.password) == password ? user : nil
  end

  def confirmed?
    actv_code.blank?
  end

  def confirm!
    unless confirmed?
      self.actv_code = nil
      save!
    end
  end

  protected

  def initialize_values
    if new_record?
      self.uuid = SecureRandom.hex.upcase
      self.actv_code = SecureRandom.hex.upcase
    end
  end

  def encrypt_password
    self.password = BCrypt::Password.create(password)
  end
end
