class Pricepoint < ActiveRecord::Base
  has_many :pricepoint_prices, inverse_of: :pricepoint
  has_many :currencies, through: :pricepoint_prices

  validates :name, presence: true
  validates :name, uniqueness: true

  attr_accessible :name

  def amount(currency)
    pricepoint_prices.find { |price| price.currency.code == currency.code }.try(:amount)
  end
end
