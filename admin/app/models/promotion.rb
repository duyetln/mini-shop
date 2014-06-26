class Promotion < ServiceResource
  extend DefaultAll
  extend DefaultCreate
  include DefaultUpdate

  def self.instantiate(hash = {})
    super do |promotion|
      promotion.item = ServiceResource.concretize(promotion.item)
      promotion.price = Price.instantiate(promotion.price)
    end
  end
end
