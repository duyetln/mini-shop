class User < ActiveRecord::Base

  attr_accessible :first_name, :last_name, :email, :birthdate, :password

  validates :first_name,  presence: true,                   format: { with: /\A[a-zA-Z]+\z/ }
  validates :last_name,   presence: true,                   format: { with: /\A[a-zA-Z]+\z/ }
  validates :email,       presence: true, uniqueness: true, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ }
  validates :birthdate,   presence: true
  validates :password,    presence: true, length: { minimum: 5 }

  before_create :set_uuid
  before_create :set_confirmation_code
  before_save   :encrypt_password

  def self.authenticate(uuid, password)
    user = find_by_uuid(uuid)
    user.present? && user.confirmed? && BCrypt::Password.new(user.password) == password ? user : nil
  end

  def confirmed?
    persisted? && confirmation_code.blank?
  end

  def confirm!
    if persisted? && confirmation_code.present?
      self.confirmation_code = nil
      save
    end
  end

  protected

  def set_uuid
    self.uuid = SecureRandom.hex(10)
  end

  def set_confirmation_code
    self.confirmation_code = SecureRandom.hex
  end

  def encrypt_password
    self.password = BCrypt::Password.create(password) if password_changed?
  end

end