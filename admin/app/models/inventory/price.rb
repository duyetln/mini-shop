class Price < ServiceResource
  extend DefaultAll
  extend DefaultCreate
  include DefaultUpdate

  def self.instantiate(hash = {})
    super do |price|
      price.pricepoint = Pricepoint.all.find { |pricepoint| pricepoint.id == price.pricepoint_id }
      price.discount = Discount.all.find { |discount| discount.id == price.discount_id }
    end
  end
end
