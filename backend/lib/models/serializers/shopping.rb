require 'models/serializers/base'
require 'models/serializers/shared'

class AddressSerializer < ServiceResourceSerializer
  attributes :user_id, :line1, :line2, :line3, :city, :region, :postal_code, :country
end

class PaymentMethodSerializer < ServiceResourceSerializer
  attributes :user_id, :name, :balance, :currency_id
end

class TransactionSerializer < ServiceResourceSerializer
  include CommittableSerializer
  attributes :user_id, :uuid, :payment_method_id, :billing_address_id, :amount, :currency_id, :created_at
end

class OrderSerializer < ServiceResourceSerializer
  include ItemCombinableSerializer
  include DeletableSerializer
  attributes :uuid, :purchase_id, :currency_id, :amount, :tax, :tax_rate, :qty, :refund_id, :created_at
  has_one :refund, serializer: 'TransactionSerializer'
  has_one :status, serializer: 'StatusSerializer'
end

class PurchaseSerializer < ServiceResourceSerializer
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
