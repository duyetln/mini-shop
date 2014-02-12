class Pricepoint < ActiveRecord::Base

  has_many :pricepoint_prices
  has_many :currencies, through: :pricepoint_prices

  validates :name, presence: true
  validates :name, uniqueness: true

  def amount(currency)
    currency_id = currency.instance_of?(Currency) && currency.id || Currency.find_by_code(currency).try(:id)
    pricepoint_prices.where(currency_id: currency_id).first.try(:amount)
  end
end