class PaymentMethod < ActiveRecord::Base

  attr_accessible :user_id, :name, :balance

  belongs_to :user
  belongs_to :currency

  validates :user_id, presence: true
  validates :name,    presence: true
  validates :balance, presence: true
  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  validates :currency_id, presence: true
  validates :currency,    presence: true

  validates :user, presence: true

  def enough?(amount=0)
    balance >= amount
  end
  
end