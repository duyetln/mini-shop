=begin
dependencies: must have 'price_id' column
interface methods:
  price_id
  price_id=
  price
  amount
  discounted?
=end

module Priceable
  extend ActiveSupport::Concern

  included do
    belongs_to :price

    validates :price, presence: true
    delegate :amount, to: :price
    delegate :discounted?, to: :price
  end
end
