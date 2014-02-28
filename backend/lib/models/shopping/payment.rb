class Payment < ActiveRecord::Base

  belongs_to :payment_method
  belongs_to :billing_address, class_name: "Address"

  attr_accessible :user_id, :payment_method_id, :billing_address_id, :amount, :currency_id

  belongs_to :user
  belongs_to :currency

  validates :user_id,             presence: true
  validates :payment_method_id,   presence: true
  validates :billing_address_id,  presence: true
  validates :currency_id,         presence: true
  validates :amount,  presence: true
  validates :amount,  numericality: { greater_than: 0 }

  validates :user,              presence: true
  validates :payment_method,    presence: true
  validates :billing_address,   presence: true
  validates :currency,          presence: true

  scope :committed, -> { where(committed: true) }
  scope :pending,   -> { where(committed: false) }

  before_create :set_values

  delegate :currency, to: :payment_method, prefix: true

  def pending?
    !committed?
  end

  def commit!
    if persisted? && pending?
      payment_method.balance -= Currency.exchange(amount, currency.code, payment_method_currency.code)
      payment_method.save!
      self.committed    = true
      self.committed_at = DateTime.now
      save!
    end
  end

  protected

  def set_values
    self.uuid = SecureRandom.hex.upcase
    self.committed    = false
    self.committed_at = nil
    self.refunded = false
    true
  end
end