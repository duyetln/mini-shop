class Price < ActiveRecord::Base
  belongs_to :pricepoint
  belongs_to :discount

  validates :pricepoint, presence: true
  validates :discount, presence: true
  validates :name, presence: true
  validates :name, uniqueness: true

  delegate :discounted?, to: :discount, allow_nil: true

  attr_accessible :name, :pricepoint_id, :discount_id

  def amount(currency)
    zero = BigDecimal.new('0.0')
    (pricepoint.amount(currency) || zero) * (1 - (discount.try(:current_rate) || zero))
  end
end
