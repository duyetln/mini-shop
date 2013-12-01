class Customer < ActiveRecord::Base

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
    customer = self.find_by_uuid(uuid)
    customer.present? && customer.confirmed? && BCrypt::Password.new(customer.password) == password ? customer : nil
  end

  def confirmed?
    self.persisted? && self.confirmation_code.blank?
  end

  def confirm!
    if self.persisted? && self.confirmation_code.present?
      self.confirmation_code = nil
      self.save
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
    self.password = BCrypt::Password.create(self.password) if self.password_changed?
  end

end