class PaymentMethod < ActiveRecord::Base
  attr_readonly :user_id, :name, :currency_id

  belongs_to :user, inverse_of: :payment_methods
  belongs_to :currency
  has_many :transactions, inverse_of: :payment_method

  validates :name,     presence: true
  validates :name,     uniqueness: true
  validates :balance,  presence: true
  validates :currency, presence: true
  validates :user,     presence: true
  validates :balance,  numericality: { greater_than_or_equal_to: 0 }

  scope :for_user, -> user_id { joins(:user).where(users: { id: user_id }).readonly(true) }

  def pending_balance
    balance - transactions.pending.reduce(BigDecimal.new('0.0')) { |a, e| a + Currency.exchange(e.amount, e.currency, currency) }
  end

  def enough?(amount = 0, input_currency = currency)
    pending_balance >= Currency.exchange(amount, input_currency, currency)
  end

  def deposit!(amount, input_currency = currency)
    self.balance += Currency.exchange(amount.abs, input_currency, currency)
    save!
  end

  def withdraw!(amount, input_currency = currency)
    self.balance -= Currency.exchange(amount.abs, input_currency, currency)
    save!
  end
end
