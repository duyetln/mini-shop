class Pricepoint < ServiceResource
  extend DefaultAll
  extend DefaultCreate
  include DefaultUpdate

  def self.instantiate(hash = {})
    super do |pricepoint|
      pricepoint.pricepoint_prices.map! do |pricepoint_price|
        PricepointPrice.instantiate(pricepoint_price)
      end
    end
  end
end
