require 'models/serializers/base'

class CurrencySerializer < ResourceSerializer
  attributes :code
end

class PricepointPriceSerializer < ResourceSerializer
  attributes :amount, :pricepoint_id, :currency_id
  has_one :currency, serializer: CurrencySerializer
end

class PricepointSerializer < ResourceSerializer
  attributes :name
  has_many :pricepoint_prices, serializer: PricepointPriceSerializer
end

class DiscountSerializer < ResourceSerializer
  attributes :name, :rate, :start_at, :end_at
end

class PriceSerializer < ResourceSerializer
  attributes :name, :pricepoint_id, :discount_id
end

module ItemResourceSerializer
  extend ActiveSupport::Concern

  included do
    attributes :title, :description, :active, :deleted, :available
  end

  def available
    object.available?
  end
end

class PhysicalItemSerializer < ResourceSerializer
  include ItemResourceSerializer
  attributes :qty
end

class DigitalItemSerializer < ResourceSerializer
  include ItemResourceSerializer
end

class BundleItemSerializer < ResourceSerializer
  include ItemResourceSerializer
  has_many :items, serializer: DynamicSerializer
end

class StorefrontItemSerializer < ResourceSerializer
  include ItemResourceSerializer
  attributes :name, :item_type, :item_id, :price_id
  has_one :price, serializer: PriceSerializer
  has_one :item, serializer: DynamicSerializer
end
