class PricepointPrice < ActiveRecord::Base

  belongs_to :pricepoint
  belongs_to :currency

  validates :amount,     presence: true
  validates :pricepoint, presence: true
  validates :currency,   presence: true

  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  validates :currency_id, uniqueness: { scope: :pricepoint_id }
end