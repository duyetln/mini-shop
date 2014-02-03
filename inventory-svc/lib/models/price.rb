class Price < ActiveRecord::Base

  belongs_to :pricepoint
  belongs_to :discount

  validates :pricepoint, presence: true
  validates :name, presence: true
  validates :name, uniqueness: true

  def amount(currency)
    zero = BigDecimal.new("0.0")

    ( self.pricepoint.amount(currency) || zero ) * ( 1 - self.discount.try(:current_rate) )
  end

end