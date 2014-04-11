class PaymentMethod < ActiveRecord::Base
  attr_readonly :user_id, :name, :currency_id

  belongs_to :user
  belongs_to :currency
  has_many   :transactions

  validates :name,     presence: true
  validates :balance,  presence: true
  validates :currency, presence: true
  validates :user,     presence: true
  validates :balance,  numericality: { greater_than_or_equal_to: 0 }

  def pending_balance
    balance - transactions.pending.reduce(BigDecimal.new('0.0')) { |a, e| a += Currency.exchange(e.amount, e.currency, currency) }
  end

  def enough?(amount = 0, input_currency = currency)
    pending_balance >= Currency.exchange(amount, input_currency, currency)
  end
end
