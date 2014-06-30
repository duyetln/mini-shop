require 'models/serializers/base'
require 'models/serializers/shared'

class CurrencySerializer < ServiceResourceSerializer
  attributes :code
end

class PricepointPriceSerializer < ServiceResourceSerializer
  attributes :amount, :pricepoint_id, :currency_id
  has_one :currency, serializer: 'CurrencySerializer'
end

class PricepointSerializer < ServiceResourceSerializer
  attributes :name
  has_many :pricepoint_prices, serializer: 'PricepointPriceSerializer'
end

class DiscountSerializer < ServiceResourceSerializer
  attributes :name, :rate, :start_at, :end_at, :discounted

  def discounted
    object.discounted?
  end
end

class PriceSerializer < ServiceResourceSerializer
  attributes :name, :pricepoint_id, :discount_id
  has_one :pricepoint, serializer: 'PricepointSerializer'
  has_one :discount, serializer: 'DiscountSerializer'
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

class PhysicalItemSerializer < ServiceResourceSerializer
  include ItemResourceSerializer
  include QuantifiableSerializer
end

class DigitalItemSerializer < ServiceResourceSerializer
  include ItemResourceSerializer
end

class BundledSerializer < ServiceResourceSerializer
  include ItemCombinableSerializer
  attributes :bundle_id
end

class BundleSerializer < ServiceResourceSerializer
  include ItemResourceSerializer
  has_many :bundleds, serializer: 'BundledSerializer'
end

class StoreItemSerializer < ServiceResourceSerializer
  include DeletableSerializer
  include DisplayableSerializer
  include ItemableSerializer
  include PriceableSerializer
  attributes :name, :active, :available

  def available
    object.available?
  end

  def active
    object.active?
  end
end

class PromotionSerializer < ServiceResourceSerializer
  include DeletableSerializer
  include DisplayableSerializer
  include ActivableSerializer
  include ItemableSerializer
  include PriceableSerializer
  attributes :name
end

class BatchSerializer < ServiceResourceSerializer
  include DeletableSerializer
  include ActivableSerializer
  attributes :name
end

class CouponSerializer < ServiceResourceSerializer
  include DisplayableSerializer
  attributes :promotion_id, :batch_id, :code, :used, :used_by, :used_at

  def promotion_id
    object.promotion.id
  end
end
