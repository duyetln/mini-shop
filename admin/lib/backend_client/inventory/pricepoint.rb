module BackendClient
  class Pricepoint
    include APIResource
    include APIModel
    include DefaultAll
    include DefaultFind
    include DefaultCreate
    include DefaultUpdate

    def self.build_attributes(hash = {})
      super do |pricepoint|
        pricepoint.pricepoint_prices.map! do |pricepoint_price|
          PricepointPrice.instantiate(pricepoint_price)
        end
      end
    end

    def create_pricepoint_price(pricepoint_price = {})
      if pricepoint_price.present?
        load!(
          self.class.post(
            path: "/#{id}/pricepoint_prices",
            payload: PricepointPrice.params(pricepoint_price)
          )
        )
        pricepoint_prices.last
      end
    end

    def amount(currency)
      pricepoint_prices.find { |price| price.currency.code == currency.code }.try(:amount)
    end
  end
end
