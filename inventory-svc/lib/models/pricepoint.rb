class Pricepoint < ActiveRecord::Base

  has_many :pricepoint_prices
  has_many :currencies, through: :pricepoint_prices

  validates :name, presence: true
  validates :name, uniqueness: true

  def amount(currency)
    pricepoint_prices.where(currency_id: currency.id).first.try(:amount)
  end
end