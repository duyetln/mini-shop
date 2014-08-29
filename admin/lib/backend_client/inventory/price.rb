module BackendClient
  class Price
    include APIResource
    include APIModel
    include DefaultAll
    include DefaultFind
    include DefaultCreate
    include DefaultUpdate

    def self.build_attributes(hash = {})
      super do |price|
        price.pricepoint = Pricepoint.instantiate(price.pricepoint)
        price.discount = Discount.instantiate(price.discount)
      end
    end

    def amount(currency)
      zero = BigDecimal.new('0.0')
      (pricepoint.amount(currency) || zero) * (1 - (discount.try(:current_rate) || zero))
    end
  end
end
