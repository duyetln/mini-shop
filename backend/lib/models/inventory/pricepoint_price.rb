class PricepointPrice < ActiveRecord::Base
  attr_readonly :pricepoint_id, :currency_id

  belongs_to :pricepoint, inverse_of: :pricepoint_prices
  belongs_to :currency

  validates :amount,     presence: true
  validates :pricepoint, presence: true
  validates :currency,   presence: true

  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  validates :currency_id, uniqueness: { scope: :pricepoint_id }

  attr_accessible :amount, :pricepoint_id, :currency_id
end
