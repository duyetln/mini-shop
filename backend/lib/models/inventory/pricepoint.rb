class Pricepoint < ActiveRecord::Base

  has_many :pricepoint_prices
  has_many :currencies, through: :pricepoint_prices

  validates :name, presence: true
  validates :name, uniqueness: true

  def amount(currency)
    currency = Currency.find_by_code(currency) unless currency.instance_of?(Currency)
    pricepoint_prices.where(currency_id: currency.try(:id)).first.try(:amount)
  end
end