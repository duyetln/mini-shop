class PaymentMethod < ActiveRecord::Base

  attr_accessible :user_id, :name, :balance, :currency_id

  belongs_to :user
  belongs_to :currency
  has_many   :payments

  validates :user_id, presence: true
  validates :name,    presence: true
  validates :balance, presence: true
  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  validates :currency_id, presence: true
  validates :currency,    presence: true

  validates :user, presence: true

  def pending_balance
    balance - payments.pending.reduce(BigDecimal("0.0")) { |s,p| s += Currency.exchange(p.amount, p.currency.code, currency.code) } 
  end

  def enough?(amount=0, currency=nil)
    currency   = Currency.find_by_code(currency) unless currency.instance_of?(Currency)
    currency ||= self.currency
    pending_balance >= Currency.exchange(amount, currency.code, self.currency.code)
  end
  
end