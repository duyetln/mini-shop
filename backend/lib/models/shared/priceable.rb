module Priceable
  extend ActiveSupport::Concern

  included do

    belongs_to :price

    validates :price, presence: true
    delegate :amount, to: :price
    delegate :discounted?, to: :price
  end
end
