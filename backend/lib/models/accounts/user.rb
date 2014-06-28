class User < ActiveRecord::Base
  attr_protected :uuid, :actv_code, :confirmed
  attr_readonly :uuid

  has_many :purchases
  has_many :addresses
  has_many :payment_methods
  has_many :transactions
  has_many :ownerships
  has_many :shipments
  has_many :coupons, foreign_key: :used_by

  validates :first_name, presence: true
  validates :last_name,  presence: true
  validates :email,      presence: true
  validates :birthdate,  presence: true
  validates :password,   presence: true

  validates :first_name, format: { with: /\A[a-zA-Z]+\z/ }
  validates :last_name,  format: { with: /\A[a-zA-Z]+\z/ }
  validates :email,      format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ }

  validates :email, uniqueness: true
  validates :uuid, uniqueness: true
  validates :password, length: { minimum: 5 }

  after_initialize :initialize_values
  before_save :encrypt_password, if: :password_changed?

  scope :confirmed, -> { where(confirmed: true) }
  scope :unconfirmed, -> { where(confirmed: false) }

  def self.authenticate!(email, password)
    user = confirmed.find_by_email!(email)
    BCrypt::Password.new(user.password) == password && user
  end

  def self.confirm!(uuid, actv_code)
    user = unconfirmed.where(uuid: uuid, actv_code: actv_code).first!
    user.confirm! && user
  end

  def confirm!
    unless confirmed?
      self.actv_code = nil
      self.confirmed = true
      save!
    end
  end

  protected

  def initialize_values
    if new_record?
      self.uuid = SecureRandom.hex.upcase
      self.actv_code = SecureRandom.hex.upcase
      self.confirmed = false
    end
  end

  def encrypt_password
    self.password = BCrypt::Password.create(password)
  end
end
