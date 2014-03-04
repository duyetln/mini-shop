class User < ActiveRecord::Base

  attr_accessible :first_name, :last_name, :email, :birthdate, :password
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

  before_create :set_values
  before_save   :encrypt_password, if: :password_changed?

  def self.authenticate(uuid, password)
    user = find_by_uuid(uuid)
    user.present? && user.confirmed? && BCrypt::Password.new(user.password) == password ? user : nil
  end

  def confirmed?
    persisted? && actv_code.blank?
  end

  def confirm!
    if persisted? && actv_code.present?
      self.actv_code = nil
      save
    end
  end

  protected

  def set_values
    self.uuid = SecureRandom.hex.upcase
    self.actv_code = SecureRandom.hex.upcase
  end

  def encrypt_password
    self.password = BCrypt::Password.create(password)
  end

end