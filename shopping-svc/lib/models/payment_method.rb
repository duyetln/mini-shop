class PaymentMethod < ActiveRecord::Base

  attr_accessible :user_id, :name, :balance

  validates :user_id, presence: true
  validates :name,    presence: true
  validates :balance, presence: true
  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  def enough?(amount=0)
    balance >= amount
  end
  
end