class Pricepoint < ActiveRecord::Base

  has_many :pricepoint_prices
  has_many :currencies, through: :pricepoint_prices

  validates :name, presence: true
  validates :name, uniqueness: true

  def amount(currency)
    self.pricepoint_prices.where(currency: currency).first.try(:amount)
  end
end