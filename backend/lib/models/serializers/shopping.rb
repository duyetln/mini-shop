require 'models/serializers/base'
require 'models/serializers/shared'

class AddressSerializer < ResourceSerializer
  attributes :user_id, :line1, :line2, :line3, :city, :region, :postal_code, :country
end

class PaymentMethodSerializer < ResourceSerializer
  attributes :user_id, :name, :balance, :currency_id
end

class TransactionSerializer < ResourceSerializer
  include CommittableSerializer
  attributes :user_id, :uuid, :payment_method_id, :billing_address_id, :amount, :currency_id, :created_at
end

class OrderSerializer < ResourceSerializer
  include ItemCombinableSerializer
  include DeletableSerializer
  attributes :uuid, :purchase_id, :currency_id, :amount, :tax, :tax_rate, :qty, :refund_id, :created_at
  has_one :refund, serializer: 'TransactionSerializer'
  has_one :status, serializer: 'StatusSerializer'
end

class PurchaseSerializer < ResourceSerializer
  attributes :user_id, :payment_method_id, :billing_address_id, :shipping_address_id, :payment_id, :committed, :committed_at, :created_at
  attributes :order_ids
  has_one :payment_method, serializer: 'PaymentMethodSerializer'
  has_one :billing_address, serializer: 'AddressSerializer'
  has_one :shipping_address, serializer: 'AddressSerializer'
  has_one :payment, serializer: 'TransactionSerializer'
  has_many :orders, serializer: 'OrderSerializer'

  def order_ids
    object.orders.map(&:id)
  end
end
