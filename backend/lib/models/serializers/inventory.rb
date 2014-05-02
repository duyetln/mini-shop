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

class PhysicalItemSerializer < ResourceSerializer
  attributes :title, :description, :active, :deleted, :qty
end

class DigitalItemSerializer < ResourceSerializer
  attributes :title, :description, :active, :deleted
end

class BundleItemSerializer < ResourceSerializer
  attributes :title, :description, :active, :deleted
  has_many :items, serializer: DynamicSerializer
end

class StorefrontItemSerializer < ResourceSerializer
  attributes :name, :title, :description, :active, :deleted, :item_type, :item_id, :price_id
  has_one :price, serializer: PriceSerializer
  has_one :item, serializer: DynamicSerializer
end
