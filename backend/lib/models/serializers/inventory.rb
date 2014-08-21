require 'models/serializers/base'
require 'models/serializers/shared'

class CurrencySerializer < ResourceSerializer
  attributes :code, :sign
end

class PricepointPriceSerializer < ResourceSerializer
  attributes :amount, :pricepoint_id, :currency_id
  has_one :currency, serializer: 'CurrencySerializer'
end

class PricepointSerializer < ResourceSerializer
  attributes :name
  has_many :pricepoint_prices, serializer: 'PricepointPriceSerializer'
end

class DiscountSerializer < ResourceSerializer
  attributes :name, :rate, :start_at, :end_at, :discounted, :current_rate, :current_active

  def discounted
    object.discounted?
  end

  def current_active
    object.current_active?
  end
end

class PriceSerializer < ResourceSerializer
  attributes :name, :pricepoint_id, :discount_id
  has_one :pricepoint, serializer: 'PricepointSerializer'
  has_one :discount, serializer: 'DiscountSerializer'
end

class PhysicalItemSerializer < ResourceSerializer
  include ItemResourceSerializer
  include QuantifiableSerializer
end

class DigitalItemSerializer < ResourceSerializer
  include ItemResourceSerializer
end

class BundledSerializer < ResourceSerializer
  include ItemCombinableSerializer
  attributes :bundle_id
end

class BundleSerializer < ResourceSerializer
  include ItemResourceSerializer
  include ChangeableSerializer
  has_many :bundleds, serializer: 'BundledSerializer'
end

class StoreItemSerializer < ResourceSerializer
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

class PromotionSerializer < ResourceSerializer
  include DeletableSerializer
  include DisplayableSerializer
  include ActivableSerializer
  include ItemableSerializer
  include PriceableSerializer
  attributes :name, :available, :batch_count, :coupon_count, :used_coupon_count

  def available
    object.available?
  end

  def batch_count
    object.batches.count
  end

  def coupon_count
    object.batches.map { |x| x.coupons.count }.reduce(0, &:+)
  end

  def used_coupon_count
    object.batches.map { |x| x.coupons.used.count }.reduce(0, &:+)
  end
end

class BatchSerializer < ResourceSerializer
  include DeletableSerializer
  include ActivableSerializer
  attributes :name, :coupon_count, :used_coupon_count

  def coupon_count
    object.coupons.count
  end

  def used_coupon_count
    object.coupons.used.count
  end
end

class CouponSerializer < ResourceSerializer
  include DisplayableSerializer
  attributes :promotion_id, :batch_id, :code, :used, :used_by, :used_at, :active, :available

  def available
    object.available?
  end

  def active
    object.active?
  end

  def promotion_id
    object.promotion.id
  end
end
